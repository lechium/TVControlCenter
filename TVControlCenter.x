#import <Foundation/Foundation.h>
#import "FindProcess.h"
#include <sys/param.h>
#import <UIKit/UIKit.h>
#import "TVCCDaemonProtocol.h"
#import "TVCCDaemonListener.h"
@interface AppDelegate: UIResponder
@property (nonatomic, strong) NSXPCConnection *daemonConnection;
- (void)mattDaemon;
@end

@interface NSXPCConnection (Private)
- (id)initWithMachServiceName:(NSString*)arg1;
- (id)remoteObjectProxy;
@end

//use it to find the name of the exe that associates with the pid
extern int proc_pidpath(int, void*, uint32_t);

//easier than importing the headers necessary
@interface NSXPCConnection (bro)
- (int)processIdentifier;
@end

/**

TVControlCenter is a very basic tweak, just add another folder for processing our 3rd party bundles
and voila!

*/

%hook _TVSMModuleInfo

+(id)_defaultModuleDirectories {
    %log;
    NSMutableArray <NSURL *> *r = [%orig mutableCopy];
    [r addObject:[NSURL fileURLWithPath:@"/Library/TVSystemMenuModules"]];
    [r addObject:[NSURL fileURLWithPath:@"/fs/jb/Library/TVSystemMenuModules"]];
    NSLog(@" = %@", r);
    return r;
}

%end

%hook AppDelegate

-(BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    %log;
    BOOL orig = %orig;
    [self mattDaemon];
    return orig;
}

%new - (void)mattDaemon {
    
    [[self daemonConnection] setRemoteObjectInterface:[NSXPCInterface interfaceWithProtocol:@protocol(TVCCDaemonProtocol)]];
    [[self daemonConnection] resume];
    //NSLog(@"remoteObjectProxy: %@", [[self daemonConnection] remoteObjectProxy]);
    //[[[self daemonConnection] remoteObjectProxy] applicationRequestsScreenshot];
}

%new - (NSXPCConnection *)daemonConnection {
    id dc = objc_getAssociatedObject(self, @selector(daemonConnection));
    if (dc == nil){
        dc = [[NSXPCConnection alloc] initWithMachServiceName:@"com.nito.tvcontrold"];
        objc_setAssociatedObject(self, @selector(operationArray), dc, OBJC_ASSOCIATION_RETAIN);
    }
    return dc;
}

%end
/**

We are normally bound by whatever entitlements TVSystemMenuService is currently signed with
to determine the extent of what is possible to implement inside a control center bundle.
This hack removes that restriction entirely. Not a fan of this tbh but it will have to do for now!

*/

%hook NSXPCConnection

- (id)valueForEntitlement:(NSString *)entitlement {

    %log;
    id orig = %orig;
    int pid = [self processIdentifier];
    char path_buffer[MAXPATHLEN];
    proc_pidpath(pid, (void*)path_buffer, sizeof(path_buffer));
    NSString *processName = [[NSString stringWithUTF8String:path_buffer] lastPathComponent];
    //com.apple.private.security.container-required
    if (orig == nil){
        if ([processName isEqualToString:@"TVSystemMenuService"]){
                NSLog(@"override entitlement: %@ for name: %@",entitlement,processName);
                return [NSNumber numberWithBool:true];
        } else {
            NSLog(@"[TVControlCenter.x] %@ %@ %@ for %@ is nil!!", self,NSStringFromSelector(_cmd),entitlement, processName);
        }
    } else {
        if ([entitlement isEqualToString:@"com.apple.private.security.container-required"]){
            NSLog(@"[TVControlCenter.x] %@ %@ %@ for %@ override false!!", self,NSStringFromSelector(_cmd),entitlement, processName);
            return [NSNumber numberWithBool:false];
        }
    }
    return orig;
}

%end
