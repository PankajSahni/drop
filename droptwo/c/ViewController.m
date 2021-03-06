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
#import "GlobalSingleton.h"
#import "GameViewController.h"
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
@synthesize spinner;
- (ViewModel *) viewModelObject{
    if(!viewModelObject){
        viewModelObject = [[ViewModel alloc] init];
        viewModelObject.delegate = self;

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

- (void)loadTableData
{
   
    NSString *string_get_invites_your_turn_their_turn_from_server = @"all_data.php";
    NSString *string_my_fb_id = [GlobalSingleton sharedManager].string_my_fb_id;
    NSDictionary *dictionary_for_json_data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              string_my_fb_id,@"fb_id", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary_for_json_data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    NSDictionary *dictionary_response = [self.globalUtilityObject modelHitWebservice:(NSString *)string_get_invites_your_turn_their_turn_from_server with_json:(NSString *)jsonString];
    //NSLog(@"dictionary_response%@",dictionary_response);
    [self.viewModelObject arrayInflateInvitesYourturnTheirturnReloadRTableview:(NSDictionary *)dictionary_response];
    [spinner stopAnimating];
    [self updateMyUserIdOnServer];
    
    
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

    
    [spinner startAnimating];
    self.view.backgroundColor = 
    [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
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
        [array_section_headers addObject:@"game_invite.png"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.invites count]]];
        

    }
    if([self.viewModelObject.your_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"your_turn.png"];
        [array_rows_in_section addObject:[NSString stringWithFormat:@"%d", [self.viewModelObject.your_turn count]]];
        
    }
    if([self.viewModelObject.their_turn count] != 0)
    {
        int_sections_in_table += 1;
        [array_section_headers addObject:@"their_turn.png"];
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
        cell.contentView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"cellInner_background.png"]];
        cell.imageview_bottom_line.image = [UIImage imageNamed:@"cellInner_line.png"];
       cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

    }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"game_invite.png"])
       {
           
         NSDictionary *current_dictionary = [self.viewModelObject.invites objectAtIndex:indexPath.row];
           NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"id"];
           cell.thumbImage.profileID = profile_id;
           cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
          cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"time"]];
           


       }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"your_turn.png"])
    {
        NSDictionary *current_dictionary = [self.viewModelObject.your_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"id"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
        cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"time"]];
        
    }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"their_turn.png"])
    {
        NSDictionary *current_dictionary = [self.viewModelObject.their_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[current_dictionary valueForKey:@"id"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"name"]];
        cell.subtextValue.text = [NSString stringWithFormat:@"%@",[current_dictionary valueForKey:@"time"]];
        
    }
    return cell;
}
- (UIView *) imageForSectionHeader:(NSInteger)integer_section
{
    uiview_section_header = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 110, 5)];
    uiview_section_header.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    NSString *string_image_name = [array_section_headers objectAtIndex:integer_section];
    UIImage *image_active_section = [UIImage imageNamed:string_image_name];
UIImageView *imageview_section_header = [[UIImageView alloc] initWithImage:image_active_section];
    imageview_section_header.frame = CGRectMake(23,0,400,38);
    [uiview_section_header addSubview:imageview_section_header];
    return uiview_section_header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [self imageForSectionHeader:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

    NSDictionary *current_dictionary = [[NSDictionary alloc]init];
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"game_invite.png"])
    {
        
    current_dictionary = [self.viewModelObject.invites objectAtIndex:indexPath.row];
    }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"your_turn.png"])
    {
    current_dictionary = [self.viewModelObject.your_turn objectAtIndex:indexPath.row];
        
    }
    if([[array_section_headers objectAtIndex:indexPath.section] isEqualToString:@"their_turn.png"])
    {
    current_dictionary = [self.viewModelObject.their_turn objectAtIndex:indexPath.row];
        
    }
    //NSLog(@"id%@",[current_dictionary valueForKey:@"id"]);
    GameViewController *_viewCntrl =[[GameViewController alloc]init];
    [self.navigationController pushViewController:_viewCntrl animated:YES];

    
}


- (void)updateMyUserIdOnServer 
{
    NSString *string_my_fb_id = [GlobalSingleton sharedManager].string_my_fb_id;
    NSString *string_my_fb_name = [GlobalSingleton sharedManager].string_my_fb_name;
    NSString *string_my_device_token = [GlobalSingleton sharedManager].string_my_device_token;
    NSString *string_update_user_id = @"user.php";
    NSDictionary *dictionary_for_json_data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            string_my_fb_id,@"fb_id",string_my_fb_name,@"name",
                                              string_my_device_token,@"device_token",@"ios", @"device_type", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary_for_json_data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"JSON Output: %@", jsonString);
    [self.globalUtilityObject modelHitWebservice:(NSString *)string_update_user_id with_json:(NSString *)jsonString];
}
@end
