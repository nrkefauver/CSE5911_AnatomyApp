//
//  ExpandingCell.h
//  HomePage
//
//  Created by oblena, erika danielle on 6/2/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel  *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel  *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel  *textLabel;
@property (strong, nonatomic) IBOutlet UILabel  *definitionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@end
