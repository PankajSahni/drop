//
//  ListFriendsCell.m
//  droptwo
//
//  Created by Mac on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListFriendsCell.h"

@implementation ListFriendsCell
@synthesize mainText;// = _mainText;
@synthesize subtextTitle;// = _subtextTitle;
@synthesize thumbImage;// = _thumbImage;
@synthesize subtextValue;// = _subtextValue;
@synthesize imageview_bottom_line;
//@synthesize customCell = _customCell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.contentView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
