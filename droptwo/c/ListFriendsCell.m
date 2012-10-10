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
//@synthesize customCell = _customCell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
