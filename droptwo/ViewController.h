//
//  ViewController.h
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
//    FBProfilePictureView *userProfileImage;
//    UILabel *userNameLabel;
}
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property(strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;

-(IBAction)logout:(UIButton *)sender;
-(IBAction)inviteFriends:(UIButton *)sender;
@end
