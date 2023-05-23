#import <Foundation/Foundation.h>
#import "TVCCDaemonProtocol.h"

@interface NSXPCConnection (brother)

@property (copy) void (^invalidationHandler)(void);
@property (copy) void (^interruptionHandler)(void);
- (void)resume;
- (void)suspend;
- (void)invalidate;
@end
/*
@interface NSXPCInterface : NSObject

+ (NSXPCInterface *)interfaceWithProtocol:(Protocol *)protocol;

@property (assign) Protocol *protocol;

- (void)setClasses:(NSSet<Class> *)classes forSelector:(SEL)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;
- (NSSet<Class> *)classesForSelector:(SEL)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;
- (void)setInterface:(NSXPCInterface *)ifc forSelector:(SEL)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;
- (NSXPCInterface *)interfaceForSelector:(SEL)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;

@end

@interface NSXPCListener : NSObject
- (id)initWithMachServiceName:(NSString*)arg1;
- (void)resume;
- (void)suspend;
- (void)invalidate;
@property id delegate;

@end

@protocol NSXPCListenerDelegate <NSObject>
@optional
-(BOOL)listener:(id)arg1 shouldAcceptNewConnection:(id)arg2;

@end
*/
@interface TVCCDaemonListener : NSObject <NSXPCListenerDelegate, TVCCDaemonProtocol> {
    
}

- (void)initialiseListener;
- (void)applicationRequestsScreenshot;
@end
