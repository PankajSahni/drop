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
@synthesize invites;

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
        //NSMutableArray *your_move =[dict valueForKey:@"your_move"];
        //NSMutableArray *their_move =[dict valueForKey:@"their_move"];
        

    
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [invites count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check to see if there is a cell to reuse a cell is rolled off.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // if there is no cell avilable create a new one.
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Add a detail view accessory
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // set the cell text
    NSDictionary *dict = [invites objectAtIndex:indexPath.row];
    NSString *profile = (NSString*)[dict valueForKey:@"fb_profileId"];
    NSString *invite_date = (NSString*)[dict valueForKey:@"invite_date"];
    cell.textLabel.text = profile;
    
    return cell;
}

@end
