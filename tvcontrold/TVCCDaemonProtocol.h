@protocol TVCCDaemonProtocol <NSObject>
@optional
- (void)applicationDidBecomeActive;
- (void)applicationDidDeactivate;
- (void)applicationDidFinishTask;

- (void)applicationRequestsPreferencesUpdate;
- (void)applicationRequestsScreenshot;
- (void)applicationRequestsTaskRun:(NSDictionary *)taskInfo;
- (void)runProcess:(NSString *)call withCompletion:(void(^)(NSString *output, NSInteger returnStatus))block;
@end
