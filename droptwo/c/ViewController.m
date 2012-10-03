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
@synthesize array_dictionary_in_current_section;
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
    array_dictionary_in_current_section = [[NSMutableArray alloc] init];
    if([self.viewModelObject.invites count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"Game Invites"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.invites count]]];
        [array_dictionary_in_current_section addObject:self.viewModelObject.invites];

    }
    if([self.viewModelObject.your_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"Your Turn"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.your_turn count]]];
        [array_dictionary_in_current_section addObject:self.viewModelObject.your_turn];
    }
    if([self.viewModelObject.their_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"Their Turn"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.their_turn count]]];
        [array_dictionary_in_current_section addObject:self.viewModelObject.their_turn];
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
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Game Invites"])
       {
           
         NSDictionary *current_dictionary = [self.viewModelObject.invites objectAtIndex:indexPath.row];
           NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"fb_profileId"];
           cell.thumbImage.profileID = profile_id;
           cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
           cell.subtextTitle.text = @"Invitation Sent: ";
           cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"date"]];

       }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Your Turn"])
    {
        NSDictionary *current_dictionary = [self.viewModelObject.your_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
        cell.subtextTitle.text = @"Invitation Sent: ";
        cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"date"]];
        
    }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"Their Invites"])
    {
        NSDictionary *current_dictionary = [self.viewModelObject.their_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
        cell.subtextTitle.text = @"Invitation Sent: ";
        cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"date"]];
        
    }    
    return cell;
}

@end
