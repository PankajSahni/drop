//
//  ViewController.h
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *news;
    NSMutableData *data;
    IBOutlet UITableView *mainTableView;
}
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property(strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) NSMutableArray *invites;
@property (nonatomic, retain) NSMutableArray *your_turn;
@property (nonatomic, retain) NSMutableArray *their_turn;




-(IBAction)logout:(UIButton *)sender;
-(IBAction)inviteFriends:(UIButton *)sender;
@end
