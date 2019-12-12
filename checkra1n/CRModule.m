#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TVSystemMenuUI/TVSMButtonViewController.h>
#include "CRModule.h"

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(BOOL)openApplicationWithBundleID:(id)arg1;
@end

@implementation CRModule

+(long long)buttonStyle {
    return TVSMActionButtonStyleMedium;
}

-(id)contentViewController {

    TVSMButtonViewController *buttonController = (TVSMButtonViewController*)[super contentViewController];
    [buttonController setStyle:TVSMActionButtonStyleMedium];
    NSString *packageFile = [[self bundle] pathForResource:@"checkra1n" ofType:@"png"];
    //important to make this a template image so it works properly with both light and dark mode
    UIImage *theImage = [[UIImage imageWithContentsOfFile:packageFile] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [buttonController setImage:theImage];
    return buttonController;
}

-(void)handleAction {

    LSApplicationWorkspace *ws = [LSApplicationWorkspace defaultWorkspace];
    [ws openApplicationWithBundleID:@"kjc.loader"];

}

-(BOOL)dismissAfterAction {
    return TRUE;
}

@end
