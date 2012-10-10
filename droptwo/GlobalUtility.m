//
//  GlobalUtility.m
//  droptwo
//
//  Created by Mac on 03/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalUtility.h"

@implementation GlobalUtility
@synthesize delegate_refresh_my_data;

-(NSDictionary *)modelHitWebservice:(NSString *)hit_page with_json:(NSString *)json_data;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *webservice_url = [NSURL URLWithString:[kBaseUrl stringByAppendingString:hit_page]];
    NSMutableURLRequest *webservice_request = [NSMutableURLRequest requestWithURL:webservice_url];
    [webservice_request setHTTPMethod:@"POST"];
    NSString *request_body = [NSString stringWithFormat:@"json_data=%@",[json_data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
    [webservice_request setHTTPBody:[request_body dataUsingEncoding:NSUTF8StringEncoding]];
    //active_webservice_connection = [[NSURLConnection alloc] initWithRequest:webservice_request delegate:self];
    //NSString *url_string = [[webservice_request URL] path];
    NSURLResponse *response = NULL;
    NSError *error = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:webservice_request returningResponse:&response error:&error];
    NSDictionary *dictionary_from_json_response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    //NSLog(@"%@",dictionary_from_json_response);
    return dictionary_from_json_response;
}

@end
