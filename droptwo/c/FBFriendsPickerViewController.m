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
		NSLog(@"yes");
        NSString *invited_by = [GlobalSingleton sharedManager].string_my_fb_id;
        NSDictionary *dictionary_invite_fb_id = 
        [[NSDictionary alloc]initWithObjectsAndKeys:string_invite_fb_profile_id,@"fb_id",
         string_invite_fb_name,@"name",invited_by,@"invited_by", nil];
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary_invite_fb_id options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //[dictionary_invite_fb_id 
        NSString *string_get_invites_your_turn_their_turn_from_server = @"invite_friend.php";
        NSDictionary *dictionary_response = [self.globalUtilityObject modelHitWebservice:(NSString *)string_get_invites_your_turn_their_turn_from_server with_json:jsonString];
        NSLog(@"response%@",dictionary_response);
        
        NSMutableDictionary  *postVariablesDictionary = [[NSMutableDictionary alloc] init];
        // [postVariablesDictionary setObject:@"me" forKey:@"name"]; 
        // [postVariablesDictionary setObject:self.image forKey:@"picture"];
        [postVariablesDictionary setObject:@"Sample Text" forKey:@"message"];
        NSString *string_fb_app_logo_path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
        UIImage *image_fb_app_logo = [[UIImage alloc]initWithContentsOfFile:string_fb_app_logo_path];
NSString *temp = @"http://wp.appadvice.com/wp-content/uploads/2010/06/Rocket-Racing-LeagueLarge.jpg";
        NSString *link = @"http://developers.facebook.com/docs/howtos/publish-to-feed-ios-sdk/";
        [postVariablesDictionary setObject:temp forKey:@"source"];
        [postVariablesDictionary setObject:link forKey:@"link"];
        NSLog(@"postVariablesDictionary%@",postVariablesDictionary);
        
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed",string_invite_fb_profile_id] parameters:postVariablesDictionary HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"result %@",result);
            NSLog(@"error %@",error);
                    }];

	}
	else if (buttonIndex == 1)
	{
		NSLog(@"No");
	}
}
@end
