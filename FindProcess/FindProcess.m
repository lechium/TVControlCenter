


#import "FindProcess.h"
#import <objc/runtime.h>

#include <stdio.h>
#include <stdint.h>
#include <mach/mach.h>
#include <dlfcn.h>
#include <pthread.h>
#include <unistd.h>

#import <Foundation/Foundation.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>
#include <sys/cdefs.h>
#include <sys/types.h>
#include <sys/param.h>
#include <mach/boolean.h>
#include <dispatch/dispatch.h>
#include <stdlib.h>
#include <spawn.h>
#include <assert.h>
#import <Foundation/Foundation.h>
#import <Security/Security.h>



extern char*** _NSGetEnviron(void);
extern int proc_listallpids(void*, int);
extern int proc_pidpath(int, void*, uint32_t);
static int process_buffer_size = 4096;

@implementation FindProcess

+ (NSString *)processNameFromPID:(pid_t)ppid {
    char path_buffer[MAXPATHLEN];
    proc_pidpath(ppid, (void*)path_buffer, sizeof(path_buffer));
    return [NSString stringWithUTF8String:path_buffer];
}

//plucked and modified from AppSyncUnified

+ (pid_t) find_process:(const char*) name fuzzy:(boolean_t)fuzzy {
    pid_t *pid_buffer;
    char path_buffer[MAXPATHLEN];
    int count, i, ret;
    boolean_t res = FALSE;
    pid_t ppid_ret = 0;
    pid_buffer = (pid_t*)calloc(1, process_buffer_size);
    assert(pid_buffer != NULL);
    
    count = proc_listallpids(pid_buffer, process_buffer_size);
    if(count) {
        for(i = 0; i < count; i++) {
            pid_t ppid = pid_buffer[i];
            
            ret = proc_pidpath(ppid, (void*)path_buffer, sizeof(path_buffer));
            if(ret < 0) {
                printf("(%s:%d) proc_pidinfo() call failed.\n", __FILE__, __LINE__);
                continue;
            }
            
            NSString *pb = [NSString stringWithUTF8String:path_buffer];
            
            NSLog(@"comparing %@ to %@", pb, [NSString stringWithUTF8String:name]);
            
            /*
            if (fuzzy){
                res = (strncmp(path_buffer, name, strlen(path_buffer)) == 0);
            } else {
                res = (strstr(path_buffer, name));
            }
            if (res){
                ppid_ret = ppid;
                break;
            }
             */
            /*
            if (strncmp(path_buffer, name, strlen(path_buffer)) == 0){
                res = TRUE;
                ppid_ret = ppid;
                break;
            }
            */
            if(strstr(path_buffer, name)) {
                res = TRUE;
                ppid_ret = ppid;
                break;
            }
        }
    }
    
    free(pid_buffer);
    return ppid_ret;
}

@end



