#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TVSystemMenuUI/TVSMButtonViewController.h>
#include "HWModule.h"

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

@end

@implementation HWModule

-(void)contentModuleViewControllerDidTriggerAction:(id)arg1 {
    
    [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/PineBoardServices.framework/"] load];
    Class PBSSystemServiceConnection = NSClassFromString(@"PBSSystemServiceConnection");
    id connection = [PBSSystemServiceConnection sharedConnection];
    id ssp = [connection systemServiceProxy];
    [ssp relaunchBackboardd];
    NSLog(@"[HWModule] did trigger connection: %@ ssp: %@", connection, ssp);
}

+(long long)buttonStyle {
    return 2;
}

-(id)contentViewController {
    
    id orig = [super contentViewController];
    NSLog(@"[HWModule] my bundle:%@", [NSBundle mainBundle]);
    NSLog(@"[HWModule] orig:%@", orig);
    TVSMButtonViewController *buttonController = [[TVSMButtonViewController alloc] init];
    [buttonController setTitleText:@"HEY! YOU!, LOOK OVER HERE!!!"];
    [buttonController setSecondaryText:@"(we really out here)"];
    [buttonController setStyle:2];
    [buttonController setDelegate:self];
    NSLog(@"[HWModule] my bundle:%@", [self bundle]);
    NSString *packageFile = [[self bundle] pathForResource:@"Package" ofType:@"png"];
    [buttonController setImage:[UIImage imageWithContentsOfFile:packageFile]];
    //[buttonController setImage:[UIImage imageNamed:@"Package"]];
    
    
    return buttonController;
}

-(void)handleAction {

    NSLog(@"handleAction");
    
}

-(BOOL)dismissAfterAction {
    return TRUE;
}

@end
