//
//  DFLBuildNewPlaylistViewController.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/17/14.
//
//

#import <UIKit/UIKit.h>
#import "DFLPlaylistObject.h"

@interface DFLBuildNewPlaylistViewController : UIViewController

@property DFLPlaylistObject *playlist;
@property (nonatomic, strong) IBOutlet UITextField *playlistNameTextInput;


@end
