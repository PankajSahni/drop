//
//  GameViewController.m
//  droptwo
//
//  Created by Mac on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "GameModel.h"
#import "GlobalSingleton.h"
@interface GameViewController ()
@property (readonly) GameModel *gameModelObject; 
@property (readonly) GlobalUtility *globalUtilityObject;
@end

@implementation GameViewController
@synthesize view_game_background;
@synthesize view_game_yellow_board;
@synthesize dictionary_martix_players;
@synthesize array_x_cordinates;
@synthesize array_y_cordinates;
@synthesize int_rows;
@synthesize int_columns;
@synthesize int_ball_width;
@synthesize int_ball_height;
@synthesize int_scrolled_upto_column;
@synthesize spinner;

- (GameModel *) gameModelObject{
    if(!gameModelObject){
        gameModelObject = [[GameModel alloc] init];
        gameModelObject.delegate = self;
        
    }
    return gameModelObject;
}
- (GlobalUtility *) globalUtilityObject{
    if(!globalUtilityObject){
        globalUtilityObject = [[GlobalUtility alloc] init];
    }
    return globalUtilityObject;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [spinner startAnimating];
    NSLog(@"reached");
    int_rows = 7;
    int_columns = 6;
    [self generateTwoDimensionalMatrixWithRows:(int)int_rows AndColumns:(int)int_columns];
    self.view.backgroundColor = 
    [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self createGameInterface];
    [self loadPlayersAtPositions];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)createGameInterface
{
    [self createGameBackgroundTopBottomMargin:(int)20];
}

- (void)createGameBackgroundTopBottomMargin:(int)int_top_bottom_margin
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat int_screen_width = (int)screenRect.size.width;
    CGFloat int_screen_height = (int)screenRect.size.height;
    int integer_status_bar_height = [UIApplication sharedApplication].statusBarFrame.size.height;
    int integer_navigation_bar_height = [[self.navigationController navigationBar] frame].size.height;
    int int_screen_height_actual = int_screen_height - integer_status_bar_height - integer_navigation_bar_height;
    int int_leave_percent_height = (int_screen_height_actual * int_top_bottom_margin)/100;
    int int_game_background_height = 
    int_screen_height_actual - 2*int_leave_percent_height;
    int int_game_background_width = int_screen_width;
    int int_game_background_x = 0; 
    int int_game_background_y = int_leave_percent_height;
    CGRect frame_view_game_background = CGRectMake(int_game_background_x,int_game_background_y,int_game_background_width,int_game_background_height);
    view_game_background = [[UIView alloc] initWithFrame:frame_view_game_background];
    //view_game_background.backgroundColor = [UIColor redColor];
    [self.view addSubview:view_game_background];
    
    int int_left_right_margin_yellow_background = 15;
    int int_top_bottom_margin_yellow_background = 15;
    int int_yellow_background_width = int_screen_width - int_left_right_margin_yellow_background * 2;
    int int_yellow_background_height = 
    int_game_background_height - int_top_bottom_margin_yellow_background * 2;
    int int_yellow_background_x = 15;
    int int_yellow_background_y = int_game_background_y + int_top_bottom_margin_yellow_background;
    CGRect frame_view_game_yellow_board = CGRectMake(int_yellow_background_x,int_yellow_background_y,int_yellow_background_width,int_yellow_background_height);
    view_game_yellow_board = [[UIView alloc] initWithFrame:frame_view_game_yellow_board];
    view_game_yellow_board.backgroundColor = 
    [UIColor colorWithRed:219/255.0f green:171/255.0f blue:38/255.0f alpha:1];
    [self.view addSubview:view_game_yellow_board];
    
    UIImage *image_yellow_board_top_shadow = [UIImage imageNamed:@"yellow_board_top_shadow.png"];
    UIImageView *imageview_yellow_board_top_shadow = 
    [[UIImageView alloc] initWithImage:image_yellow_board_top_shadow];
    CGRect frame_yellow_board_top_shadow = CGRectMake(int_yellow_background_x,int_yellow_background_y,int_yellow_background_width,4);
    imageview_yellow_board_top_shadow.frame = frame_yellow_board_top_shadow;
    [self.view addSubview:imageview_yellow_board_top_shadow];
    
    
    int_ball_width = (int_yellow_background_width*76)/(int_rows*100);
    int_ball_height = (int_yellow_background_height*80)/(int_columns*100);
    int int_ball_width_x_margin = (int_yellow_background_width*22)/(int_rows*100);
    int int_ball_width_y_margin = (int_yellow_background_height*20)/(int_columns*100);
    int int_ball_container_x = int_yellow_background_x + int_ball_width_x_margin;
    int int_ball_container_y = int_yellow_background_y + int_ball_width_y_margin;
    int int_loop_started = 0;
    int int_start_with_y = int_ball_container_y;
    array_x_cordinates = [[NSMutableArray alloc] init ];
    array_y_cordinates = [[NSMutableArray alloc] init ];
for (int int_horizontal = 1; int_horizontal <= int_rows; int_horizontal = int_horizontal + 1) {
    if(int_horizontal != 1){
        int_ball_container_x = int_ball_container_x + int_ball_width + int_ball_width_x_margin;
    }
        int_ball_container_y = int_start_with_y;
    CGRect frame_ball_container = 
    CGRectMake(int_ball_container_x , int_ball_container_y-35, int_ball_width,int_ball_height);
    
    
    UIImage *image_drop_arrow = [UIImage imageNamed:@"arrow-down.png"];
    imageview_drop_arrow = [[UIImageView alloc] initWithImage:image_drop_arrow];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gestureRecognizer.cancelsTouchesInView = YES; 
    imageview_drop_arrow.userInteractionEnabled = YES;
    [imageview_drop_arrow addGestureRecognizer:gestureRecognizer];
    
    
    imageview_drop_arrow.frame = frame_ball_container;
    
    
    [self.view addSubview:imageview_drop_arrow]; 
    [array_x_cordinates addObject:[NSString stringWithFormat:@"%d",int_ball_container_x]];
        for (int int_vetrical = 1; int_vetrical <= int_columns; int_vetrical = int_vetrical + 1) {
            
            if(int_loop_started == int_ball_container_x && int_vetrical != 1){
            int_ball_container_y = int_ball_container_y + int_ball_height + int_ball_width_y_margin;  
            }
            if(int_horizontal == 1){
                [array_y_cordinates addObject:[NSString stringWithFormat:@"%d",int_ball_container_y]];
            }
            
            
            
            CGRect frame_ball_container = 
            CGRectMake(int_ball_container_x, int_ball_container_y,int_ball_width,int_ball_height);
            UIImage *image_ball_container = [UIImage imageNamed:@"game_inner_circle.png"];
        UIImageView *imageview_ball_container = [[UIImageView alloc] initWithImage:image_ball_container];
            imageview_ball_container.backgroundColor = 
            [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
            imageview_ball_container.frame = frame_ball_container;
            [self.view addSubview:imageview_ball_container];  
            int_loop_started = int_ball_container_x;
        }
    
        int_loop_started = 0;
    } 
    //NSLog(@"con x: %@",array_x_cordinates);
    //NSLog(@"con y: %@",array_y_cordinates);
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {

    UIView* imageView_tapped_cg_rect = gestureRecognizer.view;
    int int_x_clicked = imageView_tapped_cg_rect.frame.origin.x;
    int int_active_row = 0;
    int int_temp_x = 0;
    for (int row = 0; row < int_rows; row ++) {
        int_temp_x = [[array_x_cordinates  objectAtIndex:row] intValue];
        if (int_x_clicked == int_temp_x) {
            int_active_row = row;
        }
    }
    NSString *string_active_row = [NSString stringWithFormat:@"%d", int_active_row];
    UIImage *image_ball = [UIImage imageNamed:@"blue_ball.png"];
    imageview_ball = [[UIImageView alloc] initWithImage:image_ball];
    int_scrolled_upto_column = 0;
    int x_axis = [[array_x_cordinates objectAtIndex:int_active_row] intValue];
    int y_axis = [[array_y_cordinates objectAtIndex:0] intValue];
    
    CGRect frame_ball = 
    CGRectMake(x_axis, y_axis - 22, int_ball_width, int_ball_height);
    
    imageview_ball.frame = frame_ball;
    [self.view addSubview:imageview_ball];
    timer_animate_to_last_available_column = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(dropBallToLowestPossibleColumn:) userInfo:string_active_row repeats:YES];

}

-(void) generateTwoDimensionalMatrixWithRows:(int)n_rows AndColumns:(int)n_columns{
    dictionary_martix_players = [[NSMutableDictionary alloc] init ];
    for (int row = 0; row < n_rows; row ++) {
        for (int column = 0; column < n_columns; column ++) {
            NSString *row_and_column = [NSString stringWithFormat:@"%d%d",row,column];
        [dictionary_martix_players setValue:@"empty" forKey:row_and_column];
        }
    }
}
- (void)dropBallToLowestPossibleColumn:(NSTimer *)timer
{
    NSString *string_active_row = timer.userInfo;
    int int_active_row = [string_active_row intValue];
    NSString *game_id = @"25";
    NSString *row_and_column = [NSString stringWithFormat:@"%d%d",int_active_row,int_scrolled_upto_column];
        NSString *player_at_position = [dictionary_martix_players valueForKey:row_and_column];
        if ([player_at_position isEqualToString:@"empty"]) {
            [imageview_ball removeFromSuperview];
            int x_axis = [[array_x_cordinates objectAtIndex:int_active_row] intValue];
            int y_axis = [[array_y_cordinates objectAtIndex:int_scrolled_upto_column] intValue];
             
            CGRect frame_ball = 
            CGRectMake(x_axis+1, y_axis-2, int_ball_width, int_ball_height);
            
            imageview_ball.frame = frame_ball;
            [self.view addSubview:imageview_ball];
    }
        else{
            NSString *string_my_fb_id = 
            [GlobalSingleton sharedManager].string_my_fb_id;
            [dictionary_martix_players 
             setValue:string_my_fb_id
             forKey:row_and_column];
            [self updateMyTurnForGameId:(NSString *)game_id WithX:(int)int_active_row AndY:(int)int_scrolled_upto_column]; 
            [timer_animate_to_last_available_column invalidate];
            timer_animate_to_last_available_column = nil;
        }
    int_scrolled_upto_column = int_scrolled_upto_column + 1;
    if(int_scrolled_upto_column == int_columns){
        [dictionary_martix_players 
         setValue:[GlobalSingleton sharedManager].string_my_fb_id
         forKey:row_and_column];
        
        [self updateMyTurnForGameId:(NSString *)game_id WithX:(int)int_active_row AndY:(int)int_scrolled_upto_column]; 
        
        [timer_animate_to_last_available_column invalidate];
        timer_animate_to_last_available_column = nil;
    }
} 



- (void)loadPlayersAtPositions
{
    
    NSString *string_get_all_turns_for_game = @"get_all_turns_for_game.php";
    NSString *string_game_id = @"29";
    NSDictionary *dictionary_for_json_data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              string_game_id,@"game_id", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary_for_json_data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    NSDictionary *dictionary_response = [self.globalUtilityObject modelHitWebservice:(NSString *)string_get_all_turns_for_game with_json:(NSString *)jsonString];
    NSString *string_status = [dictionary_response valueForKey:@"STATUS"];
    //NSLog(@"string_status %@",string_status);
    if ([string_status isEqualToString:@"1"]) {
        NSArray *array_response = [[NSArray alloc] init];
        array_response = [dictionary_response valueForKey:@"TURNS"];
        //NSLog(@"array %@",array_response);
        NSString *string_my_fb_id = [GlobalSingleton sharedManager].string_my_fb_id;
        for (NSDictionary *dictionary_turn in array_response) {
            NSString *string_position_x = [dictionary_turn objectForKey:@"position_x"];
            NSString *string_position_y = [dictionary_turn objectForKey:@"position_y"];
            int int_position_x = [string_position_x intValue];
            int int_position_y = [string_position_y intValue];
            NSString *row_and_column = [NSString stringWithFormat:@"%d%d",int_position_x,int_position_y];
            NSString *turn_by = [dictionary_turn objectForKey:@"turn_by"];
            [dictionary_martix_players setValue:turn_by forKey:row_and_column];
            UIImage *image_ball;
            if ([turn_by isEqualToString:string_my_fb_id]) {
                image_ball = [UIImage imageNamed:@"blue_ball.png"];
            }
            else{
                image_ball = [UIImage imageNamed:@"red_ball.png"];
            }
            imageview_ball = [[UIImageView alloc] initWithImage:image_ball];
            int x_axis = [[array_x_cordinates objectAtIndex:int_position_x] intValue];
            int y_axis = [[array_y_cordinates objectAtIndex:int_position_y] intValue];  
            CGRect frame_ball = 
            CGRectMake(x_axis, y_axis, int_ball_width, int_ball_height);
            imageview_ball.frame = frame_ball;
            [self.view addSubview:imageview_ball];
        }
        [self.view setNeedsDisplay];
    }
    [spinner stopAnimating];
}
- (void)updateMyTurnForGameId:(NSString *)string_game_id WithX:(int)int_x AndY:(int)int_y
{
    NSString *string_get_all_turns_for_game = @"turns.php";
    NSString *string_my_fb_id = [GlobalSingleton sharedManager].string_my_fb_id;
    NSString *string_x = [NSString stringWithFormat:@"%d", int_x];
    NSString *string_y = [NSString stringWithFormat:@"%d", int_y];
    NSDictionary *dictionary_for_json_data = [[NSDictionary alloc] initWithObjectsAndKeys:
    string_game_id,@"game_id", string_x, @"position_x",string_y, @"position_y",
                                              string_my_fb_id, @"turn_by", @"1", @"status", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary_for_json_data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //
    NSDictionary *dictionary_response = [self.globalUtilityObject modelHitWebservice:(NSString *)string_get_all_turns_for_game with_json:(NSString *)jsonString];
    //NSString *string_status = [dictionary_response valueForKey:@"MESSAGE"];
    //NSLog(@"MESSAGE %@",string_status);
}
@end
