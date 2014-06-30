//
//  PopoverTableViewCell.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/26/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "PopoverTableViewCell.h"

@implementation PopoverTableViewCell
@synthesize titleLabel, subtitleLabel, textLabel;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
