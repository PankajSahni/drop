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
@end

@implementation ViewController
@synthesize friendPickerController = _friendPickerController;
@synthesize userNameLabel;
@synthesize userProfileImage;
@synthesize your_turn;
@synthesize their_turn;
@synthesize invites;

- (void)populateUserDetails 
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, 
           NSDictionary<FBGraphUser> *user, 
           NSError *error) {
             if (!error) {
                 //NSLog(@"%@",user.id);
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
/*    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc] 
                                       initWithNibName:nil bundle:nil];
        
        // Set the friend picker delegate
        self.friendPickerController.delegate = self;
        
        self.friendPickerController.title = @"Select friends";
    }
    
    [self.friendPickerController loadData];
    [self.navigationController pushViewController:self.friendPickerController animated:true];*/
 FBFriendsPickerViewController *_viewCntrl =[[FBFriendsPickerViewController alloc]init];
 [self.navigationController pushViewController:_viewCntrl animated:YES];
 }
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     data = [[NSMutableData alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) 
     name:SCSessionStateChangedNotification object:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:@"http://mstage.ruckusreader.com/iphone/json.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
 NSURLConnection *demoConnection =   [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (demoConnection) {
         data = [NSMutableData data];
    }
    else {
        NSLog(@"Network problem");
    }
    
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
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
    [data appendData:mydata];  
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    

    
    
    
    //NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]  ;
    NSError * error = nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    

    
    

        
        invites =[dict valueForKey:@"invites"];
        your_turn =[dict valueForKey:@"your_move"];
        their_turn =[dict valueForKey:@"their_move"];
        

    
    [mainTableView reloadData];
    
    
   
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc]initWithTitle:@"error" message:@"data cannot be downloaded" delegate:nil cancelButtonTitle:@"Dismissss" otherButtonTitles:nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
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


-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(section == 0)
       return [invites count];
    else if(section == 1)
        return [your_turn count];
    else {
        return [their_turn count];
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
    NSDictionary *invites_dictionary = [invites objectAtIndex:indexPath.row];
    NSString *profile_id = (NSString*)[invites_dictionary valueForKey:@"fb_profileId"];
    cell.thumbImage.profileID = profile_id;
    cell.mainText.text = (NSString*)[invites_dictionary valueForKey:@"fb_profileId"];
    cell.subtextTitle.text = @"sub_title";
    cell.subtextValue.text = (NSString*)[invites_dictionary valueForKey:@"invite_date"];   
    }
    else if (indexPath.section == 1) {
        NSDictionary *your_turn_dictionary = [your_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[your_turn_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[your_turn_dictionary valueForKey:@"fb_profileId"];
        cell.subtextTitle.text = @"sub_title";
        cell.subtextValue.text = (NSString*)[your_turn_dictionary valueForKey:@"last_move_date"];   
    }
    else {
        NSDictionary *their_turn_dictionary = [their_turn objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[their_turn_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[their_turn_dictionary valueForKey:@"fb_profileId"];
        cell.subtextTitle.text = @"sub_title";
        cell.subtextValue.text = (NSString*)[their_turn_dictionary valueForKey:@"last_move_date"];
    }

    
    return cell;
}

@end
