//
//  FBFriendsPickerViewController.m
//  droptwo
//
//  Created by Mac on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBFriendsPickerViewController.h"

#import "ListFriendsCell.h"
#import "GlobalSingleton.h"
#import "GlobalUtility.h"
@interface FBFriendsPickerViewController ()
@property (readonly) FBFriendsPickerModel *fBFriendsPickerModelObject; 
@property (readonly) GlobalUtility *globalUtilityObject; 
@end

@implementation FBFriendsPickerViewController
@synthesize invites;
@synthesize array_fb_friends_not_playing_with_me;
@synthesize string_invite_fb_name;
@synthesize string_invite_fb_profile_id;
- (FBFriendsPickerModel *) fBFriendsPickerModelObject{
    if(!fBFriendsPickerModelObject){
        fBFriendsPickerModelObject = [[FBFriendsPickerModel alloc] init];
    }
    return fBFriendsPickerModelObject;
}
- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
        globalUtilityObject.delegate_refresh_my_data = self;
    }
    return globalUtilityObject;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)logout:(UIButton *)sender 
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = 
    //[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [[GlobalSingleton sharedManager]array_friends_already_invited];
    array_fb_friends_not_playing_with_me = [[NSMutableArray alloc]init ];
    array_fb_friends_not_playing_with_me = [self.fBFriendsPickerModelObject 
                          getFacebookFriendsNotInvitedOrPlaying:[[GlobalSingleton sharedManager]array_friends_already_invited]];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return [array_fb_friends_not_playing_with_me count];
    
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
    NSArray *array_profile_id_and_name = [array_fb_friends_not_playing_with_me objectAtIndex: indexPath.row];
        NSString *profile_id = [array_profile_id_and_name objectAtIndex:0];
        NSString *name = [array_profile_id_and_name objectAtIndex:1];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = name;
        cell.subtextTitle.text = @"";
        cell.subtextValue.text = @""; 

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    /NSLog(@"cell%@",indexPath.row);
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Confirm"];
	[alert setMessage:@"Do you pick Yes or No?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
    NSArray *array_profile_id_and_name = [array_fb_friends_not_playing_with_me objectAtIndex: indexPath.row];
    string_invite_fb_profile_id = [array_profile_id_and_name objectAtIndex:0];
    string_invite_fb_name = [array_profile_id_and_name objectAtIndex:1];
    
    //NSLog(@"profile_id%@",profile_id);
    // do stuff with cell
    //
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *invited_by = [GlobalSingleton sharedManager].string_my_fb_id;
        NSDictionary *dictionary_invite_fb_id = 
        [[NSDictionary alloc]initWithObjectsAndKeys:string_invite_fb_profile_id,@"fb_id",
         string_invite_fb_name,@"name",invited_by,@"invited_by", nil];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary_invite_fb_id options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *string_get_invites_your_turn_their_turn_from_server = @"invite_friend.php";
   [self.globalUtilityObject modelHitWebservice:(NSString *)string_get_invites_your_turn_their_turn_from_server with_json:jsonString];
        
        NSMutableDictionary  *dictionary_to_post = [[NSMutableDictionary alloc] init];        
        NSString *string_app_logo_link = @"http://wp.appadvice.com/wp-content/uploads/2010/06/Rocket-Racing-LeagueLarge.jpg";
        NSString *string_app_itunes_link = @"http://developers.facebook.com/docs/howtos/publish-to-feed-ios-sdk/";
        NSString *string_app_fb_message = @"Sample Text 123";
        [dictionary_to_post setObject:string_app_fb_message forKey:@"message"];
        [dictionary_to_post setObject:string_app_logo_link forKey:@"source"];
        [dictionary_to_post setObject:string_app_itunes_link forKey:@"link"];
        [self.globalUtilityObject facebookPost:(NSDictionary *)dictionary_to_post ToFBFriend:(NSString *)string_invite_fb_profile_id];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	else if (buttonIndex == 1)
	{
		NSLog(@"No");
	}
}
@end
