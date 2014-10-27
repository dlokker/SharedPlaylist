//
//  DFLTestItem.h
//  SharedPlaylist
//
//  Created by Derek Lokker on 7/15/14.
//
//

#import <Foundation/Foundation.h>

@interface DFLTestItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
