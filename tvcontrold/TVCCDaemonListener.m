#import <Foundation/NSString.h>
#import <Foundation/Foundation.h>
#import "TVCCDaemonListener.h"
#import "TVCCApplicationProtocol.h"
#import "NSTask.h"
#import <notify.h>
#import <UIKit/UIKit.h>

extern  UIImage* _UICreateScreenUIImage();

#define APPLICATION_IDENTIFIER "com.apple.TVSystemMenuService"

///////////////////////////////////////////////////////////////////////////
// Private API
///////////////////////////////////////////////////////////////////////////

@implementation NSTask (convenience)

- (void) waitUntilExit {
    
    NSTimer    *timer = nil;
    while ([self isRunning]) {
        NSDate    *limit = nil;
        
        limit = [[NSDate alloc] initWithTimeIntervalSinceNow: 0.1];
        if (timer == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
            timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                     target: nil
                                                   selector: @selector(class)
                                                   userInfo: nil
                                                    repeats: YES];
#pragma clang diagnostic pop
        }
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                 beforeDate: limit];
    }
    [timer invalidate];
}

@end

#if __cplusplus
extern "C" {
#endif
    // SpringBoardServices
    BOOL SBSProcessIDForDisplayIdentifier(CFStringRef identifier, pid_t *pid);
    
    // Needs the com.apple.backboardd.launchapplications entitlement
    int SBSLaunchApplicationWithIdentifierAndLaunchOptions(CFStringRef identifier, CFDictionaryRef launchOptions, BOOL suspended);
    CFStringRef SBSApplicationLaunchingErrorString(int error);
    
    // BackBoardServices
    
#define BKSProcessAssertionFlagNone 0
#define BKSProcessAssertionFlagPreventSuspend (1 << 0)
#define BKSProcessAssertionFlagPreventThrottleDownCPU (1 << 1)
#define BKSProcessAssertionFlagAllowIdleSleep (1 << 2)
#define BKSProcessAssertionFlagWantsForegroundResourcePriority (1 << 3)
    
    typedef enum {
        BKSProcessAssertionReasonNone,
        BKSProcessAssertionReasonAudio,
        BKSProcessAssertionReasonLocation,
        BKSProcessAssertionReasonExternalAccessory,
        BKSProcessAssertionReasonFinishTask,
        BKSProcessAssertionReasonBluetooth,
        BKSProcessAssertionReasonNetworkAuthentication,
        BKSProcessAssertionReasonBackgroundUI,
        BKSProcessAssertionReasonInterAppAudioStreaming,
        BKSProcessAssertionReasonViewServices
    } BKSProcessAssertionReason;
    
#if __cplusplus
}
#endif

extern NSString* BKSActivateForEventOptionTypeBackgroundContentFetching;
extern NSString* BKSOpenApplicationOptionKeyActivateForEvent;

@interface BKSProcessAssertion : NSObject
- (id)initWithPID:(pid_t)arg1 flags:(unsigned int)arg2 reason:(BKSProcessAssertionReason)arg3 name:(NSString*)arg4 withHandler:(void (^)(BOOL success))arg5;
- (void)invalidate;
@end

@interface TVCCDaemonListener ()

@property (nonatomic, strong) NSDictionary *settings;

@property (nonatomic, strong) NSTimer *assertionFallbackTimer;

@property (nonatomic, strong) BKSProcessAssertion *applicationBackgroundAssertion;
@property (nonatomic, strong) NSXPCConnection* xpcConnection;
@property (nonatomic, strong) NSMutableArray *pendingXpcConnectionQueue;

@end

@implementation TVCCDaemonListener

- (void)initialiseListener {
  
    //[self reloadSettings];
    
}

- (void)applicationRequestsScreenshot {
    UIImage *screenImage = _UICreateScreenUIImage();
    NSData *pngData = UIImagePNGRepresentation(screenImage);
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *outputFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", @"TVControlScreenshot"]];//[NSString stringWithFormat:@"/private/var/mobile/Documents/%@.png", name];
    [pngData writeToFile:outputFile atomically:YES];
    NSLog(@"screenshot was saved to: %s\n", [outputFile UTF8String]);
}

- (void)runProcess:(NSString *)call withCompletion:(void(^)(NSString *output, NSInteger returnStatus))block {
    
    NSArray *args = [call componentsSeparatedByString:@" "];
    NSString *taskBinary = args[0];
    NSArray *taskArguments = [args subarrayWithRange:NSMakeRange(1, args.count-1)];
    //DDLogInfo(@"%@ %@", taskBinary, [taskArguments componentsJoinedByString:@" "]);
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *handle = [pipe fileHandleForReading];
    
    [task setLaunchPath:taskBinary];
    [task setArguments:taskArguments];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    
    [task launch];
    
    NSData *outData = nil;
    NSString *temp = nil;
    while((outData = [handle readDataToEndOfFile]) && [outData length]){
        temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
    }
    [handle closeFile];
    [task waitUntilExit];
    int termStatus = [task terminationStatus];
    task = nil;
    if (block){
        block(temp, termStatus);
    }
}

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    // Configure bi-directional communication
    NSLog(@"*** [tvcontrold] :: shouldAcceptNewConnection recieved.");
    
    [newConnection setExportedInterface:[NSXPCInterface interfaceWithProtocol:@protocol(TVCCDaemonProtocol)]];
    [newConnection setExportedObject:self];
    
    self.xpcConnection = newConnection;
    
    // State management for the main application
    // When it is e.g. killed, then the invalidation handler is called
    __weak TVCCDaemonListener *weakSelf = self;
    self.xpcConnection.interruptionHandler = ^{
        NSLog(@"*** tvcontrold :: Interruption handler called");
        [weakSelf.xpcConnection invalidate];
        weakSelf.xpcConnection = nil;
    };
    self.xpcConnection.invalidationHandler = ^{
        NSLog(@"*** tvcontrold :: Invalidation handler called");
        [weakSelf.xpcConnection invalidate];
        weakSelf.xpcConnection = nil;
    };
    
    newConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol: @protocol(TVCCApplicationProtocol)];
    [newConnection resume];
    
    return YES;
}

- (void)remoteObjectProxyErrorHandler:(NSInteger)notification {
    NSLog(@"*** tvcontrold :: Queuing notification %lu until connection is established", (unsigned long)notification);
    // Drop the message onto a queue, and go from there
    if (!self.pendingXpcConnectionQueue)
        self.pendingXpcConnectionQueue = [NSMutableArray array];
    
    [self.pendingXpcConnectionQueue addObject:[NSNumber numberWithInt:notification]];
}

@end
