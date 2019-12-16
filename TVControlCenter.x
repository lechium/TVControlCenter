#import <Foundation/Foundation.h>
#import "FindProcess.h"
#include <sys/param.h>

extern int proc_pidpath(int, void*, uint32_t);

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
        char path_buffer[MAXPATHLEN];
        proc_pidpath(pid, (void*)path_buffer, sizeof(path_buffer));
        NSString *processName = [NSString stringWithUTF8String:path_buffer];
        if ([processName isEqualToString:@"TVSystemMenuService"]){
                NSLog(@"override entitlement: %@ for name: %@",entitlement,processName);
                return [NSNumber numberWithBool:true];
        }
    }
    return orig;
}

%end
