//
//  FindProcess.h
//  
//
//  Created by Kevin Bradley on 5/20/19.
//

#import <Foundation/Foundation.h>

@interface FindProcess : NSObject
+ (NSString *)processNameFromPID:(pid_t)ppid;
+ (pid_t) find_process:(const char*)name fuzzy:(boolean_t)fuzzy;
@end


