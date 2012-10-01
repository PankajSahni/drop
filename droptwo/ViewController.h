//
//  ViewController.h
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"
@interface ViewController : UIViewController<NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *mainTableView;
    ViewModel *viewModelObject;

}

@property(strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, retain) NSMutableArray *array_section_headers;
@property (nonatomic, retain) NSMutableArray *array_rows_in_section;
@property (nonatomic, retain) NSMutableArray *array_dictionary_in_current_section;

@property (nonatomic, assign) NSInteger int_sections_in_table;

- (void)refreshData;
-(IBAction)logout:(UIButton *)sender;
-(IBAction)inviteFriends:(UIButton *)sender;
@end
