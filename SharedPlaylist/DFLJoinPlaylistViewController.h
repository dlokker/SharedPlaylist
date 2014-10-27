//
//  DFLJoinPlaylistViewController.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/22/14.
//
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface DFLJoinPlaylistViewController : UIViewController <MCBrowserViewControllerDelegate>

- (IBAction)searchForConnections:(id)sender;

@end
