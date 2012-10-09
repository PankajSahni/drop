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
@synthesize delegate_refresh_my_data;


/*
-(id)init
{
    if(self=[super init])
    {
        if(self.array_friends_already_invited==nil)
            self.array_friends_already_invited = [[NSMutableArray alloc] init];
    }
    return self;
}
*/

-(void)arrayInflateInvitesYourturnTheirturnReloadRTableview:(NSDictionary *)dictionary_response
{
    NSMutableArray *array_friends_already_invited = [[NSMutableArray alloc]init ];
    
    invites =[dictionary_response valueForKey:@"invites"];
    
    your_turn =[dictionary_response valueForKey:@"your_move"];
    
    their_turn =[dictionary_response valueForKey:@"their_move"];
    
    for (NSDictionary *object_dictionary in invites) {
        NSString *profile_id = [object_dictionary objectForKey:@"fb_profileId"];
        [array_friends_already_invited addObject:profile_id];
    }
    for (NSDictionary *object_dictionary in your_turn) {
        NSString *profile_id = [object_dictionary objectForKey:@"fb_profileId"];
        [array_friends_already_invited addObject:profile_id];
    }
    for (NSDictionary *object_dictionary in their_turn) {
        NSString *profile_id = [object_dictionary objectForKey:@"fb_profileId"];
        [array_friends_already_invited addObject:profile_id];
    }
    [GlobalSingleton sharedManager].array_friends_already_invited = array_friends_already_invited;
    //NSLog(@"array_friends_already_invited%@",[GlobalSingleton sharedManager].array_friends_already_invited);
    [(ViewController*)delegate_refresh_my_data refreshData];
}


@end
