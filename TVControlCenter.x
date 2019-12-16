#import <Foundation/Foundation.h>
#import "FindProcess.h"
#include <sys/param.h>

//use it to find the name of the exe that associates with the pid
extern int proc_pidpath(int, void*, uint32_t);

//easier than importing the headers necessary
@interface NSXPCConnection: NSObject
- (int)processIdentifier;
@end

/**

TVControlCenter is a very basic tweak, just add another folder for processing our 3rd party bundles
and voila!

*/

%hook _TVSMModuleInfo

+(id)_defaultModuleDirectories {
    %log;
    NSMutableArray <NSURL *> *r = [%orig mutableCopy];
    [r addObject:[NSURL fileURLWithPath:@"/Library/TVSystemMenuModules"]];
    HBLogDebug(@" = %@", r);
    return r;
}

%end

/**

We are normally bound by whatever entitlements TVSystemMenuService is currently signed with
to determine the extent of what is possible to implement inside a control center bundle.
This hack removes that restriction entirely. Not a fan of this tbh but it will have to do for now!

*/

%hook NSXPCConnection

- (id)valueForEntitlement:(NSString *)entitlement {

    id orig = %orig;
    if (orig == nil){
        int pid = [self processIdentifier];
        char path_buffer[MAXPATHLEN];
        proc_pidpath(pid, (void*)path_buffer, sizeof(path_buffer));
        NSString *processName = [[NSString stringWithUTF8String:path_buffer] lastPathComponent];
        if ([processName isEqualToString:@"TVSystemMenuService"]){
                NSLog(@"override entitlement: %@ for name: %@",entitlement,processName);
                return [NSNumber numberWithBool:true];
        } else {
            NSLog(@"[TVControlCenter.x] %@ %@ %@ for %@ is nil!!", self,NSStringFromSelector(_cmd),entitlement, processName);
        }
    }
    return orig;
}

%end
