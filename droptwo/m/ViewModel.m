//
//  ViewModel.m
//  droptwo
//
//  Created by Mac on 25/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewModel.h"
#import "ViewController.h"
#import "GlobalSingleton.h"
@implementation ViewModel
@synthesize your_turn;
@synthesize their_turn;
@synthesize invites;
@synthesize delegate;


-(void)arrayInflateInvitesYourturnTheirturnReloadRTableview:(NSDictionary *)dictionary_response
{
    NSMutableArray *array_friends_already_invited = [[NSMutableArray alloc]init ];
    
    invites =[dictionary_response valueForKey:@"game_invites"];
    
    your_turn =[dictionary_response valueForKey:@"my_turns"];
    
    their_turn =[dictionary_response valueForKey:@"their_turns"];
    
    for (NSDictionary *object_dictionary in invites) {
        NSString *profile_id = [object_dictionary objectForKey:@"id"];
        [array_friends_already_invited addObject:profile_id];
    }
    for (NSDictionary *object_dictionary in your_turn) {
        NSString *profile_id = [object_dictionary objectForKey:@"id"];
        [array_friends_already_invited addObject:profile_id];
    }
    for (NSDictionary *object_dictionary in their_turn) {
        NSString *profile_id = [object_dictionary objectForKey:@"id"];
        [array_friends_already_invited addObject:profile_id];
    }
    [GlobalSingleton sharedManager].array_friends_already_invited = array_friends_already_invited;
    [delegate refreshData];
}

- (void)updateMyUserIdInTheAppSingleton 
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, 
           NSDictionary<FBGraphUser> *user, 
           NSError *error) {
             if (!error) {
                 [GlobalSingleton sharedManager].string_my_fb_id = (NSString *) user.id;
                 [GlobalSingleton sharedManager].string_my_fb_name = (NSString *) user.name;
                 [delegate loadTableData];    
             }
         }];      
    }
}
@end
