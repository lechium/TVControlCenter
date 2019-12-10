# TVControlCenter
Research &amp; Documentation on implementation of control center bundles on tvOS 13+

Control Center on tvOS is split up into 3 components: TVSystemMenuService (An invisible application), TVSystemMenuUI.framework (a private framework) and a series of bundles (stored in /System/Library/TVSystemMenuModules)

## TVSystemMenuService

This application is the control center of well... control center, it handles the actual UI that is displayed to the user and the handling of whic modules are available and visible.

Doing very broad cursory coverage of each component, this information is hot off the presses!

_TVSMModuleInfo calls +(id)_defaultModuleDirectories which currently only points towards '/System/Library/TVSystemMenuModules'

This is an ideal place to inject so we can get our own bundles loaded, interestingly enough putting our bundles directly in /System/Library/TVSystemMenuModules removes the need to do any code injection to get our bundles to load with no extra work needed.

## TVSystemMenuUI.framework

The private framework that contains all the classes we will be inheriting from to create a bundle for control center.

I took the header dump from the basic 'Sleep Module' to determine how these bundles work, it is a perfect template to create our own simple bundle off of.

Header file

```Objective-C

#import <TVSystemMenuUI/TVSMActionModule.h>

@interface TestModule : TVSMActionModule

+(long long)buttonStyle;
-(id)contentViewController;
-(void)handleAction;
-(BOOL)dismissAfterAction;

@end

```

Implementation file

```Objective-C
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TVSystemMenuUI/TVSMButtonViewController.h>
#include "TestModule.h"

@implementation TestModule

-(void)contentModuleViewControllerDidTriggerAction:(id)arg1 {
    //not sure if this is only called because i set the delagate below or not
}

+(long long)buttonStyle {
    return 2; //don't know what the different styles are yet, this is the same used by the Sleep Module
}

-(id)contentViewController {

    id orig = [super contentViewController];
    //might just be able to use orig instead of creating new TVSMButtonViewController
    TVSMButtonViewController *buttonController = [[TVSMButtonViewController alloc] init];
    [buttonController setTitleText:@"HEY! YOU!, LOOK OVER HERE!!!"];
    [buttonController setSecondaryText:@"(we really out here)"];
    [buttonController setStyle:2];
    [buttonController setDelegate:self];
    NSString *packageFile = [[self bundle] pathForResource:@"Package" ofType:@"png"];
    [buttonController setImage:[UIImage imageWithContentsOfFile:packageFile]];
    return buttonController;
}

-(void)handleAction {

    NSLog(@"handleAction"); //never trigged, not sure if its because I set the above delegate or not

}

-(BOOL)dismissAfterAction {
    return TRUE;
}

@end
```

## Samples

There are header dumps of all the afformentioned existing plugins available on this repo, a mostly working theos template & a sample project (the one i showed the video of earlier today on twitter)

There is an aggegate theos sample that will build the tweak needed to run plugins from /Library/TVSystemMenuModules instead of the default system path AND the sample HelloWorld plugin, it attempts to restart backboardd, but that part isnt quite working yet. 


