//
//  ViewModel.h
//  droptwo
//
//  Created by Mac on 25/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject


@property (nonatomic, retain) NSMutableArray *invites;
@property (nonatomic, retain) NSMutableArray *your_turn;
@property (nonatomic, retain) NSMutableArray *their_turn;

@property (nonatomic, retain)id delegate_refresh_my_data;

-(void)inflate_arrays_invites_your_turn_their_turn_and_reload_tableview:(NSDictionary *)dictionary;

@end
