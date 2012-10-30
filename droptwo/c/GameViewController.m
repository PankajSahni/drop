//
//  GameViewController.m
//  droptwo
//
//  Created by Mac on 22/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

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
    
    NSLog(@"reached");
    int_rows = 7;
    int_columns = 6;
    [self generateTwoDimensionalMatrixWithRows:(int)int_rows AndColumns:(int)int_columns];
    self.view.backgroundColor = 
    [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self createGameInterface];
    
    
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
    view_game_background.backgroundColor = [UIColor redColor];
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
    
    
    int_ball_width = (int_yellow_background_width*65)/(int_rows*100);
    int_ball_height = (int_yellow_background_height*65)/(int_columns*100);
    int int_ball_width_x_margin = (int_yellow_background_width*32)/(int_rows*100);
    int int_ball_width_y_margin = (int_yellow_background_height*30)/(int_columns*100);
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
    UIImageView *imageview_drop_arrow = [[UIImageView alloc] initWithImage:image_drop_arrow];
    
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
    for (int column = 0; column < int_columns; column ++) {
        NSString *row_and_column = [NSString stringWithFormat:@"%d%d",int_active_row,column];
        NSString *player_at_position = [dictionary_martix_players valueForKey:row_and_column];
        if ([player_at_position isEqualToString:@"empty"]) {
            int x_axis = [[array_x_cordinates objectAtIndex:int_active_row] intValue];
            int y_axis = [[array_y_cordinates objectAtIndex:column] intValue];
            UIImage *image_ball = [UIImage imageNamed:@"blue_ball.png"]; 
            CGRect frame_ball = 
            CGRectMake(x_axis, y_axis, int_ball_width, int_ball_height);
            UIImageView *imageview_ball = [[UIImageView alloc] initWithImage:image_ball];
            imageview_ball.frame = frame_ball;
            [self.view addSubview:imageview_ball]; 
        }
        
    }
}

-(void) generateTwoDimensionalMatrixWithRows:(int)n_rows AndColumns:(int)n_columns{
    dictionary_martix_players = [[NSMutableDictionary alloc] init ];
    for (int row = 0; row < n_rows; row ++) {
        for (int column = 0; column < n_columns; column ++) {
            NSString *row_and_column = [NSString stringWithFormat:@"%d%d",row,column];
        [dictionary_martix_players setValue:@"empty" forKey:row_and_column];
        }
    }
    //NSLog(@"dictionary_martix_players: %@",dictionary_martix_players);
}
@end
