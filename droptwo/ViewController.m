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
@synthesize array_section_headers;
@synthesize int_sections_in_table;
@synthesize array_rows_in_section;
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




/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 34.0;
}*/
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [array_section_headers objectAtIndex:section];
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    int_sections_in_table = 0;
    array_section_headers = [[NSMutableArray alloc] init];
    array_rows_in_section = [[NSMutableArray alloc] init];
    if([self.viewModelObject.invites count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"Game Invites"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.invites count]]];

    }
    if([self.viewModelObject.your_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"Your Turn"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.your_turn count]]];
    }
    if([self.viewModelObject.their_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"Their Invites"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.their_turn count]]];
    }    
     return int_sections_in_table;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[array_rows_in_section objectAtIndex:section] integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListFriendsCell *cell = (ListFriendsCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListFriendsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.section == 0 && [self.viewModelObject.invites count] != 0)
    {
    NSDictionary *invites_dictionary = [self.viewModelObject.invites objectAtIndex:indexPath.row];
    NSString *profile_id = (NSString*)[invites_dictionary valueForKey:@"fb_profileId"];
        
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[invites_dictionary valueForKey:@"name"]; 
        cell.subtextTitle.text = @"Invitation Sent: ";
        cell.subtextValue.text = (NSString*)[invites_dictionary valueForKey:@"invite_date"];   
    }
    else if(indexPath.section == 0 && [self.viewModelObject.invites count] == 0)
    {
        cell.mainText.text = @"Please invite your friends to play with you%@"; 
        cell.subtextTitle.text = @"";
        cell.subtextValue.text = @"";
    }
    if(indexPath.section == 1 && [self.viewModelObject.your_turn count] != 0) 
    {
        NSDictionary *your_turn_dictionary = [self.viewModelObject.your_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[your_turn_dictionary valueForKey:@"fb_profileId"];
        
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[your_turn_dictionary valueForKey:@"name"];
        cell.subtextTitle.text = @"Last Move: ";
        cell.subtextValue.text = (NSString*)[your_turn_dictionary valueForKey:@"last_move_date"];   
    }
    if(indexPath.section == 2 && [self.viewModelObject.their_turn count] != 0)
    {
        NSDictionary *their_turn_dictionary = [self.viewModelObject.their_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[their_turn_dictionary valueForKey:@"fb_profileId"];
        
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[their_turn_dictionary valueForKey:@"name"];
        cell.subtextTitle.text = @"Last Move: ";
        cell.subtextValue.text = (NSString*)[their_turn_dictionary valueForKey:@"last_move_date"];
    }

    
    return cell;
}

@end
