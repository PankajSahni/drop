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
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity: 3];
    
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:0];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:1];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil] atIndex:2];
    //NSLog(@"array %@",dataArray);
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
    //NSLog(@"width %lf",int_leave_percent_height);
    CGRect frame_view_game_background = CGRectMake(int_game_background_x,int_game_background_y,int_game_background_width,int_game_background_height);
    view_game_background = [[UIView alloc] initWithFrame:frame_view_game_background];
    view_game_background.backgroundColor = [UIColor redColor];
    [self.view addSubview:view_game_background];
    
    int int_left_right_margin_yellow_background = 5;
    int int_top_bottom_margin_yellow_background = 5;
    int int_yellow_background_width = int_screen_width - int_left_right_margin_yellow_background * 2;
    int int_yellow_background_height = 
    int_game_background_height - int_top_bottom_margin_yellow_background * 2;
    int int_yellow_background_x = 5;
    int int_yellow_background_y = int_game_background_y + int_top_bottom_margin_yellow_background;
    CGRect frame_view_game_yellow_board = CGRectMake(int_yellow_background_x,int_yellow_background_y,int_yellow_background_width,int_yellow_background_height);
    view_game_yellow_board = [[UIView alloc] initWithFrame:frame_view_game_yellow_board];
    view_game_yellow_board.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view_game_yellow_board];
    
    int int_ball_container_x_static = int_yellow_background_x + 5;
    int int_ball_container_y_static = int_yellow_background_y + 5;
    int int_ball_container_x = int_ball_container_x_static;
    int int_ball_container_y = int_ball_container_y_static;
    int int_ball_width = 10;
    int int_ball_height = 10;
    int int_ball_width_x_margin = 20;
    int int_ball_width_y_margin = 20;
    int int_loop_started = 0;
    int int_start_with_y = int_ball_container_y + int_ball_height + int_ball_width_y_margin;
    for (int int_horizontal = 0; int_horizontal < 3; int_horizontal = int_horizontal + 1) {
        int_ball_container_x = int_ball_container_x + int_ball_width + int_ball_width_x_margin;
        
        int_ball_container_y = int_start_with_y;
        for (int int_vetrical = 0; int_vetrical < 2; int_vetrical = int_vetrical + 1) {
            if(int_loop_started == int_ball_container_x && int_vetrical != 0){
            int_ball_container_y = int_ball_container_y + int_ball_height + int_ball_width_y_margin;
            
        }
            NSLog(@"int_ball_container_x %d",int_ball_container_x);
            NSLog(@"int_ball_container_y %d",int_ball_container_y);
            CGRect frame_ball_container = 
            CGRectMake(int_ball_container_x, int_ball_container_y,int_ball_width,int_ball_height);
            UIView *view_ball_container = [[UIView alloc] initWithFrame:frame_ball_container];
            view_ball_container.backgroundColor = [UIColor blueColor];
            [self.view addSubview:view_ball_container];  
            int_loop_started = int_ball_container_x;
        }
        int_loop_started = 0;
    }
    
}
@end
