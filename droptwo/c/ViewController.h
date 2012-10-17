//
//  ViewController.h
//  droptwo
//
//  Created by Mac on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"
#import "GlobalUtility.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, delegateLoadTableData>
{
    IBOutlet UITableView *mainTableView;
    ViewModel *viewModelObject;
    GlobalUtility *globalUtilityObject;
    UIView *uiview_table_header;
    UIView *uiview_table_footer;
    UIView *uiview_section_header;
}


@property (nonatomic, retain) NSMutableArray *array_section_headers;
@property (nonatomic, retain) NSMutableArray *array_rows_in_section;
@property (nonatomic, assign) NSInteger int_sections_in_table;
@property (nonatomic, retain)IBOutlet UIView *uiview_table_header;
@property (nonatomic, retain)IBOutlet UIView *uiview_table_footer;
@property (nonatomic, retain)IBOutlet UIView *uiview_section_header;

- (ViewModel *) viewModelObject;

- (void)refreshData;

-(IBAction)logout:(UIButton *)sender;
-(IBAction)inviteFriends:(UIButton *)sender;
- (void)updateMyUserIdOnServer;

@end
