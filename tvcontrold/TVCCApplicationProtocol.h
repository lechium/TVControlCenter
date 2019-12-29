@protocol TVCCApplicationProtocol <NSObject>
@optional
- (void)daemonDidRequestQueuedNotification;
- (void)daemonDidRequestScreenshot;

@end
