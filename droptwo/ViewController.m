//
//  ViewController.m
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()
@end

@implementation ViewController
@synthesize friendPickerController = _friendPickerController;
@synthesize userNameLabel;
@synthesize userProfileImage;


- (void)populateUserDetails 
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, 
           NSDictionary<FBGraphUser> *user, 
           NSError *error) {
             if (!error) {
                 NSLog(@"%@",user.name);
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
             }
         }];      
    }
}
-(IBAction)logout:(UIButton *)sender 
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(IBAction)inviteFriends:(UIButton *)sender
{
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc] 
                                       initWithNibName:nil bundle:nil];
        
        // Set the friend picker delegate
        self.friendPickerController.delegate = self;
        
        self.friendPickerController.title = @"Select friends";
    }
    
    [self.friendPickerController loadData];
    [self.navigationController pushViewController:self.friendPickerController animated:true];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(sessionStateChanged:) 
     name:SCSessionStateChangedNotification
     object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc
{
    _friendPickerController.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}


@end
