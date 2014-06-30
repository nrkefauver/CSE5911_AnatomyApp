//
//  ExpandingCell.m
//  HomePage
//
//  Created by oblena, erika danielle on 6/2/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "ExpandingCell.h"

@implementation ExpandingCell
@synthesize textLabel, titleLabel, subtitleLabel,segmentedControl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    if (self) {
        // Initialization code
       
    }
    return self;
}

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
