//
//  GameModel.h
//  droptwo
//
//  Created by Mac on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol delegateGame
-(void) refreshData;
@end
@interface GameModel : NSObject{
    id <delegateGame> delegate;
}
-(void)dictionaryInflateMetrixPositions:(NSDictionary *)dictionary;

@property (retain, nonatomic) id <delegateGame> delegate;
@end
