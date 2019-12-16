#import "FindProcess.h"
#include <sys/param.h>

extern int proc_pidpath(int, void*, uint32_t);

@implementation FindProcess

+ (NSString *)processNameFromPID:(pid_t)ppid {
    char path_buffer[MAXPATHLEN];
    proc_pidpath(ppid, (void*)path_buffer, sizeof(path_buffer));
    return [NSString stringWithUTF8String:path_buffer];
}

@end



