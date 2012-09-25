//
//  ViewController.m
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ListFriendsCell.h"
#import "FBFriendsPickerViewController.h"
@interface ViewController ()
@property (readonly) ViewModel *viewModelObject; 
@end

@implementation ViewController

@synthesize userNameLabel;
@synthesize userProfileImage;

- (ViewModel *) viewModelObject{
    if(!viewModelObject){
        viewModelObject = [[ViewModel alloc] init];
        viewModelObject.delegate_refresh_my_data = self;
    }
    return viewModelObject;
}

- (void)refreshData
{
    [mainTableView reloadData];
}

-(IBAction)logout:(UIButton *)sender 
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(IBAction)inviteFriends:(UIButton *)sender
{
 FBFriendsPickerViewController *_viewCntrl =[[FBFriendsPickerViewController alloc]init];
 [self.navigationController pushViewController:_viewCntrl animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.viewModelObject modelGetDataFromWebServiceForSectionsInvitesYourturnTheirturn];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Game Invites";
    }
    else if (section == 1) {
        return @"Your Turn";
    }
    else {
        return @"Their Turn";
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)sessionStateChanged:(NSNotification*)notification {

}


-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        //(@"%@",self.viewModelObject.invites);
        return [self.viewModelObject.invites count];
    }
       
    else if(section == 1)
    {
        return [self.viewModelObject.your_turn count];
    }
    else 
    {
        return [self.viewModelObject.their_turn count];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListFriendsCell *cell = (ListFriendsCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListFriendsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.section == 0)
    {
    NSDictionary *invites_dictionary = [self.viewModelObject.invites objectAtIndex:indexPath.row];
    NSString *profile_id = (NSString*)[invites_dictionary valueForKey:@"fb_profileId"];
    cell.thumbImage.profileID = profile_id;
        [self.viewModelObject modelGetNameFromFBProfileId: profile_id];
        cell.mainText.text = self.viewModelObject.get_name_from_fb;
    cell.subtextTitle.text = @"sub_title";
    cell.subtextValue.text = (NSString*)[invites_dictionary valueForKey:@"invite_date"];   
    }
    else if (indexPath.section == 1) {
        NSDictionary *your_turn_dictionary = [self.viewModelObject.your_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[your_turn_dictionary valueForKey:@"fb_profileId"];
        
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[your_turn_dictionary valueForKey:@"fb_profileId"];
        cell.subtextTitle.text = @"sub_title";
        cell.subtextValue.text = (NSString*)[your_turn_dictionary valueForKey:@"last_move_date"];   
    }
    else {
        NSDictionary *their_turn_dictionary = [self.viewModelObject.their_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[their_turn_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[their_turn_dictionary valueForKey:@"fb_profileId"];
        cell.subtextTitle.text = @"sub_title";
        cell.subtextValue.text = (NSString*)[their_turn_dictionary valueForKey:@"last_move_date"];
    }

    
    return cell;
}

@end
