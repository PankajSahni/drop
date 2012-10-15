//
//  ListFriendsCell.h
//  droptwo
//
//  Created by Mac on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListFriendsCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *mainText;
@property (nonatomic, strong) IBOutlet UILabel *subtextTitle;
@property (nonatomic, strong) IBOutlet UILabel *subtextValue;
@property (nonatomic, strong) IBOutlet UIImageView *imageview_bottom_line;
//@property (strong, nonatomic) IBOutlet ListFriendsCell *customCell;
@property(strong, nonatomic) IBOutlet FBProfilePictureView *thumbImage;
@end
