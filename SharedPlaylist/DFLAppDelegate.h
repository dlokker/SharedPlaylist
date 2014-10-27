//
//  DFLAppDelegate.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/15/14.
//
//

#import <UIKit/UIKit.h>
#import "DFLMultipeerConnectivityHandler.h"

@interface DFLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) DFLMultipeerConnectivityHandler *mpcHandler;

//@property (nonatomic,strong) MCSession *session;
//@property (nonatomic,strong) MCPeerID *peerID;

//-(void) setup;

@end
