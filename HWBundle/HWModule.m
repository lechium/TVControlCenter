#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TVSystemMenuUI/TVSMButtonViewController.h>
#include "HWModule.h"

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(BOOL)openApplicationWithBundleID:(id)arg1;
@end

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

@implementation HWModule


+(long long)buttonStyle {
    return 1;
}

-(id)contentViewController {
    
    TVSMButtonViewController *buttonController = [super contentViewController];
    //TVSMButtonViewController *buttonController = [[TVSMButtonViewController alloc] init];
    //[buttonController setTitleText:@"Hello World"];
    //[buttonController setSecondaryText:@"(we really out here)"];
    [buttonController setStyle:1];
    NSString *packageFile = [[self bundle] pathForResource:@"checkra1n" ofType:@"png"];
    [buttonController setImage:[UIImage imageWithContentsOfFile:packageFile]];
    return buttonController;
}

-(void)handleAction {

    NSLog(@"[HWModule] handleAction");
    LSApplicationWorkspace *ws = [LSApplicationWorkspace defaultWorkspace];
    [ws openApplicationWithBundleID:@"kjc.loader"];
    /*
    id connection = [PBSSystemServiceConnection sharedConnection];
    id ssp = [connection systemServiceProxy];
    //[ssp setValid:true];
    //BOOL isValid = [ssp isValid];
    [ssp sleepSystemForReason:@"PBSSleepReasonUserSystemMenu"];
    //[ssp relaunchBackboardd];
    
    NSLog(@"[HWModule] did trigger connection: %@ ssp: %@", connection, ssp);
     */
}

-(BOOL)dismissAfterAction {
    return TRUE;
}

@end
