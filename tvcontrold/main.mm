#import <Foundation/NSXPCConnection.h>
#import "TVCCDaemonListener.h"



int main(int argc, const char *argv[])
{
    NSLog(@"*** [tvcontrold] :: Loading up daemon.");
    
    // initialize our daemon
    TVCCDaemonListener *daemon = [[TVCCDaemonListener alloc] init];
    [daemon initialiseListener];
    
    // Bypass compiler prohibited errors
    Class NSXPCListenerClass = NSClassFromString(@"NSXPCListener");
    
    NSXPCListener *listener = [[NSXPCListenerClass alloc] initWithMachServiceName:@"com.nito.tvcontrold"];
    listener.delegate = daemon;
    [listener resume];
    
    // Run the run loop forever.
    [[NSRunLoop currentRunLoop] run];
    
     return EXIT_SUCCESS;
}
