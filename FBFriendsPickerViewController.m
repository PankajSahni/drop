//
//  FBFriendsPickerViewController.m
//  droptwo
//
//  Created by Mac on 21/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBFriendsPickerViewController.h"
#import "AppDelegate.h"
#import "ListFriendsCell.h"
#import "ViewController.h"
@interface FBFriendsPickerViewController ()

@end

@implementation FBFriendsPickerViewController
@synthesize invites;
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
    
    
    
    [friendsPickerTableView reloadData];
    
    
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return [invites count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListFriendsCell *cell = (ListFriendsCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListFriendsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

        NSDictionary *invites_dictionary = [invites objectAtIndex:indexPath.row];
        NSString *profile_id = (NSString*)[invites_dictionary valueForKey:@"fb_profileId"];
        cell.thumbImage.profileID = profile_id;
        cell.mainText.text = (NSString*)[invites_dictionary valueForKey:@"fb_profileId"];
        cell.subtextTitle.text = @"sub_title";
        cell.subtextValue.text = (NSString*)[invites_dictionary valueForKey:@"invite_date"];   
    
    
    
    return cell;
}

@end
