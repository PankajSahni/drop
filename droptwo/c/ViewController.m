//
//  ViewController.m
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ListFriendsCell.h"
#import "GlobalUtility.h"
#import "FBFriendsPickerViewController.h"

@interface ViewController ()

@property (readonly) ViewModel *viewModelObject; 
@property (readonly) GlobalUtility *globalUtilityObject;

@end

@implementation ViewController


@synthesize array_section_headers;
@synthesize int_sections_in_table;
@synthesize array_rows_in_section;
@synthesize uiview_table_header;
@synthesize uiview_table_footer;
@synthesize uiview_section_header;
- (ViewModel *) viewModelObject{
    if(!viewModelObject){
        viewModelObject = [[ViewModel alloc] init];
    }
    return viewModelObject;
}
- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
        globalUtilityObject.delegate_refresh_my_data = self;
    }
    return globalUtilityObject;
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
    //NSLog(@"token:%@",FBSession.activeSession.accessToken); 
    self.view.backgroundColor = 
    [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    NSString *string_get_invites_your_turn_their_turn_from_server = @"json.php";
    NSDictionary *dictionary_response = [self.globalUtilityObject modelHitWebservice:(NSString *)string_get_invites_your_turn_their_turn_from_server with_json:(NSString *)nil];
    [self.viewModelObject arrayInflateInvitesYourturnTheirturnReloadRTableview:(NSDictionary *)dictionary_response];

    mainTableView.tableHeaderView = uiview_table_header;
    mainTableView.tableFooterView = uiview_table_footer;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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
        [array_section_headers addObject:@"GameInvites.png"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.invites count]]];
        

    }
    if([self.viewModelObject.your_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"YourTurn.png"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.your_turn count]]];
        
    }
    if([self.viewModelObject.their_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"YourTurn.png"];
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
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"GameInvites.png"])
       {
           
         NSDictionary *current_dictionary = [self.viewModelObject.invites objectAtIndex:indexPath.row];
           NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"fb_profileId"];
           cell.thumbImage.profileID = profile_id;
           cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
           cell.subtextTitle.text = @"Invitation Sent: ";
           cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"date"]];

       }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"YourTurn.png"])
    {
        NSDictionary *current_dictionary = [self.viewModelObject.your_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
        cell.subtextTitle.text = @"Invitation Sent: ";
        cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"date"]];
        
    }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"TheirInvites.png"])
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
- (UIView *) imageForSectionHeader:(NSInteger)integer_section
{
    uiview_section_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    uiview_section_header.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    NSString *string_image_name = [array_section_headers objectAtIndex:integer_section];
    UIImage *image_active_section = [UIImage imageNamed:string_image_name];
    UIImageView *image_section_header = [[UIImageView alloc] initWithImage:image_active_section];
    [uiview_section_header addSubview:image_section_header];
    return uiview_section_header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"aactibe view %@",[self imageForSectionHeader:section]);
    return [self imageForSectionHeader:section];
}

@end
