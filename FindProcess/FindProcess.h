//#import <Foundation/Foundation.h>

@interface FindProcess : NSObject
+ (NSString *)processNameFromPID:(pid_t)ppid;
@end


