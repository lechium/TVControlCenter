#import "KBPBSService.h"

//this is experimental and does not work yet for some reason, keeping it around for posterity / when i get more time to mess with it

@implementation KBPBSService

- (void)killbackboardd {
    
     id connection = [PBSSystemServiceConnection sharedConnection];
     id ssp = [connection systemServiceProxy];
     [ssp relaunchBackboardd];
   
}


@end
