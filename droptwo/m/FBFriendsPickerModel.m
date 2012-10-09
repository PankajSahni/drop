//
//  FBFriendsPickerModel.m
//  droptwo
//
//  Created by Mac on 08/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBFriendsPickerModel.h"
#import "ViewModel.h"
#import "GlobalSingleton.h"

@implementation FBFriendsPickerModel
@synthesize array_friends_already_invited;
@synthesize dictionary_fb_friends_from_json_response;

- (void)getFacebookFriends{
    NSString *string_url_facebook_friends = @"https://graph.facebook.com/me/friends?access_token=";
    NSURL *webservice_url = [NSURL URLWithString:[string_url_facebook_friends stringByAppendingString:FBSession.activeSession.accessToken]];
    NSMutableURLRequest *webservice_request = [NSMutableURLRequest requestWithURL:webservice_url];
    NSURLResponse *response = NULL;
    NSError *error = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:webservice_request returningResponse:&response error:&error];
    dictionary_fb_friends_from_json_response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
}
- (NSArray *)getFacebookFriendsNotInvitedOrPlaying:array_friends_already_invited{
    NSMutableArray *array_fb_friends_excluding_already_invited = [[NSMutableArray alloc] init];
    if([dictionary_fb_friends_from_json_response count] == 0){
        [self getFacebookFriends];
    }
    NSArray *array_in_data_dictionary = [dictionary_fb_friends_from_json_response objectForKey:@"data"];
     NSArray *array_temp = nil;
     for (NSDictionary *object_dictionary in array_in_data_dictionary) {

     NSString *profile_id = [object_dictionary objectForKey:@"id"];
         NSString *name = [object_dictionary objectForKey:@"name"];
         int profile_exist = 0;
         for (NSString *string_id_friends_already_invited in [GlobalSingleton sharedManager].array_friends_already_invited) {
             if ([profile_id isEqualToString:string_id_friends_already_invited]) {
                 profile_exist = 1;
             }
         }
         if (profile_exist == 0) {
             array_temp = [[NSArray alloc]initWithObjects:profile_id, name, nil];
             [array_fb_friends_excluding_already_invited addObject:array_temp];
         }
         
         array_temp = nil;
    }
    return array_fb_friends_excluding_already_invited;
}
@end
