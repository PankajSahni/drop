//
//  ViewModel.m
//  droptwo
//
//  Created by Mac on 25/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewModel.h"
#import "ViewController.h"

@implementation ViewModel
@synthesize your_turn;
@synthesize their_turn;
@synthesize invites;
@synthesize delegate_refresh_my_data;
@synthesize webservice_url;
@synthesize webservice_request;
@synthesize active_webservice_connection;
@synthesize get_webservice_file_from_request;
@synthesize get_dictionary_from_url;


-(void)modelGetDataFromWebServiceForSectionsInvitesYourturnTheirturn
{
    data = [[NSMutableData alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    webservice_url = [NSURL URLWithString:@"http://mstage.ruckusreader.com/iphone/json.php"];
    webservice_request = [NSURLRequest requestWithURL:webservice_url];
    active_webservice_connection = [[NSURLConnection alloc] initWithRequest:webservice_request delegate:self];
    NSString *url_string = [[webservice_request URL] path];
    get_webservice_file_from_request = [[url_string lastPathComponent] stringByDeletingPathExtension];
    if (active_webservice_connection) 
    {
        data = [NSMutableData data];
    }
    else 
    {
        NSLog(@"Network problem");
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
    if ([get_webservice_file_from_request isEqualToString:@"json"]) 
    {
        [data appendData:mydata];  
    }
    else {
        [data_from_fb appendData:mydata];
    }
    
    

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connection: %@",connection);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError * error = nil;
    get_dictionary_from_url = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    //NSLog(@"webservice_page: %@",get_webservice_file);
    if ([get_webservice_file_from_request isEqualToString:@"json"]) {
        invites =[get_dictionary_from_url valueForKey:@"invites"];
        your_turn =[get_dictionary_from_url valueForKey:@"your_move"];
        their_turn =[get_dictionary_from_url valueForKey:@"their_move"];

    }
    
    [(ViewController*)delegate_refresh_my_data refreshData];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *errorView = [[UIAlertView alloc]initWithTitle:@"error" message:@"data cannot be downloaded" delegate:nil cancelButtonTitle:@"Dismissss" otherButtonTitles:nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
}

-(void)modelGetNameFromFBProfileId:(NSString *)profile_id
{
    data = [[NSMutableData alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *graph_url = @"http://graph.facebook.com/";
    graph_url =[graph_url stringByAppendingString:profile_id];

    webservice_url = [NSURL URLWithString:graph_url];
    webservice_request = [NSURLRequest requestWithURL:webservice_url];
    active_webservice_connection = [[NSURLConnection alloc] initWithRequest:webservice_request delegate:self];
    NSString *url_string = [[webservice_request URL] path];
    get_webservice_file_from_request = [[url_string lastPathComponent] stringByDeletingPathExtension];
    //NSLog(@"graph %@",active_webservice_connection);
    if (active_webservice_connection) 
    {
        data_from_fb = [NSMutableData data];
    }
    else 
    {
        NSLog(@"Network problem");
    }
}
@end
