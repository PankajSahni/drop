//
//  FBFriendsPickerViewController.h
//  droptwo
//
//  Created by Mac on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFriendsPickerModel.h"
@class GlobalUtility;
@interface FBFriendsPickerViewController : UIViewController
{
IBOutlet UITableView *friendsPickerTableView;
    NSMutableData *data;
    FBFriendsPickerModel *fBFriendsPickerModelObject;
    GlobalUtility *globalUtilityObject;

}
@property (nonatomic, retain) NSMutableArray *invites;
@property (nonatomic, retain) NSArray *array_fb_friends_not_playing_with_me;
@property (nonatomic, retain) NSArray *string_invite_fb_profile_id;
@property (nonatomic, retain) NSArray *string_invite_fb_name;
    @end
