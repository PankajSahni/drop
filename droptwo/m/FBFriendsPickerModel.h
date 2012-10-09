//
//  FBFriendsPickerModel.h
//  droptwo
//
//  Created by Mac on 08/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBFriendsPickerModel : NSObject
{
}

@property (nonatomic, retain) NSMutableArray *array_friends_already_invited;
@property (nonatomic, retain) NSMutableDictionary *dictionary_fb_friends_from_json_response;

- (NSMutableArray *) getFacebookFriendsNotInvitedOrPlaying:(NSArray *)array_friends_already_invited;
@end
