//
//  DFLMultipeerConnectivityHandler.m
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/21/14.
//
//

#import "DFLMultipeerConnectivityHandler.h"

@implementation DFLMultipeerConnectivityHandler

- (void)setupPeerWithDisplayName:(NSString *)displayName {
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)setupSession {
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)setupBrowser {
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"shared-playlist" session:_session];
}

- (void)advertiseSelf:(BOOL)advertise {
    if (advertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"shared-playlist"
                                                               discoveryInfo:nil session:self.session];
        [self.advertiser start];
        
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}


// Called every time a peer's connection status changes.
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *userInfo = @{ @"peerID": peerID,
                                @"state" : @(state) };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCHandler_DidChangeStateNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

// Called every time data arrives from a peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

// Called when a stream is established
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSDictionary *userInfo = @{ @"stream": stream,
                                @"streamName": streamName,
                                @"peerID": peerID };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCHandler_DidReceiveStreamNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

@end
