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



-(void)inflate_arrays_invites_your_turn_their_turn_and_reload_tableview:(NSDictionary *)dictionary_response
{
    invites =[dictionary_response valueForKey:@"invites"];
    your_turn =[dictionary_response valueForKey:@"your_move"];
    their_turn =[dictionary_response valueForKey:@"their_move"];
    [(ViewController*)delegate_refresh_my_data refreshData];
}


@end
