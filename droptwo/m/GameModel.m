//
//  GameModel.m
//  droptwo
//
//  Created by Mac on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
@synthesize delegate;
-(void)dictionaryInflateMetrixPositions:(NSDictionary *)dictionary{
    //NSLog(@"response: %@",dictionary);
    NSString *string_status = [dictionary valueForKey:@"STATUS"];
    NSLog(@"string_status %@",string_status);
    if ([string_status isEqualToString:@"1"]) {
        NSArray *array_response = [[NSArray alloc] init];
        array_response = [dictionary valueForKey:@"TURNS"];
        NSLog(@"array %@",array_response);
    }
    
    [delegate refreshData];
}
@end
