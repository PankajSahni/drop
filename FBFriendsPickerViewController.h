//
//  FBFriendsPickerViewController.h
//  droptwo
//
//  Created by Mac on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBFriendsPickerViewController : UIViewController
{
IBOutlet UITableView *friendsPickerTableView;
    NSMutableData *data;
    
}
@property (nonatomic, retain) NSMutableArray *invites;
    @end
