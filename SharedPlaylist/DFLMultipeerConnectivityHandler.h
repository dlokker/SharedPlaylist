//
//  DFLMultipeerConnectivityHandler.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/21/14.
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface DFLMultipeerConnectivityHandler : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (void)setupPeerWithDisplayName:(NSString *)displayName;
- (void)setupSession;
- (void)setupBrowser;
- (void)advertiseSelf:(BOOL)advertise;

@end
