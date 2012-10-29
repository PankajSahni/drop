//
//  GameViewController.h
//  droptwo
//
//  Created by Mac on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
{
    UIView *view_game_background;
    UIView *view_game_yellow_board;
}
@property (nonatomic, retain) UIView *view_game_background;
@property (nonatomic, retain) UIView *view_game_yellow_board;

@property (nonatomic, retain) NSMutableDictionary *dictionary_martix_players;
@property (nonatomic, retain) NSMutableArray *array_x_cordinates;
@property (nonatomic, retain) NSMutableArray *array_y_cordinates;
@end
