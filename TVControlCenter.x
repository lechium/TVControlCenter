#import <Foundation/Foundation.h>
#import "FindProcess.h"

@interface NSXPCConnection: NSObject
- (int)processIdentifier;
@end

%hook _TVSMModuleInfo

+(id)_defaultModuleDirectories {
    %log;
    NSMutableArray <NSURL *> *r = [%orig mutableCopy];
    [r addObject:[NSURL fileURLWithPath:@"/Library/TVSystemMenuModules"]];
    HBLogDebug(@" = %@", r);
    return r;
}

%end

%hook NSXPCConnection

- (id)valueForEntitlement:(NSString *)entitlement {

    id orig = %orig;
    if (orig == nil){
        int pid = [self processIdentifier];
        NSString *processName = [[FindProcess processNameFromPID:pid] lastPathComponent];
        if ([processName isEqualToString:@"TVSystemMenuService"]){
                NSLog(@"override entitlement: %@ for name: %@",entitlement,processName);
                return [NSNumber numberWithBool:true];
        }
    }
    return orig;
}

%end
