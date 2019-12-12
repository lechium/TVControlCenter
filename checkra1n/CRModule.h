#import <TVSystemMenuUI/TVSMModuleContentViewControllerDelegate.h>
#import <TVSystemMenuUI/TVSMModuleContentViewController.h>
#import <TVSystemMenuUI/TVSMActionModule.h>

//i just made this up, but it accurately tracks the style

typedef NS_ENUM(NSInteger, TVSMActionButtonStyle) {
    TVSMActionButtonStyleSmall = 0,
    TVSMActionButtonStyleMedium,
    TVSMActionButtonStyleLarge
};


@interface CRModule : TVSMActionModule

+(long long)buttonStyle;
-(id)contentViewController;
-(void)handleAction;
-(BOOL)dismissAfterAction;
@end


