//
//  DFLMainPlaylistViewController.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/17/14.
//
//

#import <UIKit/UIKit.h>
#import "DFLPlaylistObject.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface DFLMainPlaylistViewController : UIViewController <MCBrowserViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *playlistLabel;
@property (nonatomic, strong) NSString *playlistName;
@property (nonatomic, strong) DFLPlaylistObject *playlist;

@property (nonatomic, weak) IBOutlet UILabel *connectedDevice;

@end
