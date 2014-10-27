//
//  DFLPlaylistObject.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/17/14.
//
//

#import <Foundation/Foundation.h>

@interface DFLPlaylistObject : NSObject

@property NSString *name;

// Possibly different obj later, used to hold device ID of playlist host (?)
@property NSString *creator;

@property BOOL vetoEnabled;
@property BOOL youtubeEnabled;

@end
