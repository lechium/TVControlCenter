#import "KBPBSService.h"

//this is experimental and does not work yet for some reason, keeping it around for posterity / when i get more time to mess with it

@implementation KBPBSService

- (void)killbackboardd {
    
     id connection = [PBSSystemServiceConnection sharedConnection];
     id ssp = [connection systemServiceProxy];
     //[ssp sleepSystemForReason:@"PBSSleepReasonUserSystemMenu"];
     [ssp relaunchBackboardd];
     
     NSLog(@"[CRModule] did trigger connection: %@ ssp: %@", connection, ssp);
    
}


@end
