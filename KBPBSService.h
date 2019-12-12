@interface PBSSystemService : NSObject
+(id)sharedInstance;
-(void)deactivateApplication;
-(void)registerServiceProviderEndpoint:(id)arg1 forProviderType:(id)arg2 ;
-(void)endpointForProviderType:(id)arg1 withIdentifier:(id)arg2 responseBlock:(/*^block*/id)arg3 ;
-(void)launchKioskApp;
-(void)sleepSystemForReason:(id)arg1 ;
-(void)wakeSystemForReason:(id)arg1 ;
-(void)relaunchBackboardd;
@end

@interface PBSSystemServiceConnection : NSObject
+(id)sharedConnection;
-(id)systemServiceProxy;
-(BOOL)isValid;
-(void)setValid:(BOOL)arg1;
@end

@interface KBPBSService: NSObject

@end
