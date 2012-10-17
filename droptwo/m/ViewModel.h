//
//  ViewModel.h
//  droptwo
//
//  Created by Mac on 25/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalUtility.h"

@protocol delegateLoadTableData
-(void) loadTableData;
-(void) refreshData;
@end

@interface ViewModel : NSObject
{
    GlobalUtility *globalUtilityObject;
    id <delegateLoadTableData> delegate; 
}


@property (nonatomic, retain) NSMutableArray *invites;
@property (nonatomic, retain) NSMutableArray *your_turn;
@property (nonatomic, retain) NSMutableArray *their_turn;
@property (nonatomic, retain) GlobalUtility *globalUtilityObject;
@property (retain, nonatomic) id <delegateLoadTableData> delegate;


-(void)arrayInflateInvitesYourturnTheirturnReloadRTableview:(NSDictionary *)dictionary;
- (void)updateMyUserIdInTheAppSingleton;
@end
