//
//  ExpandingCell.h
//  HomePage
//
//  Created by oblena, erika danielle on 6/2/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textLabel;

@property (strong, nonatomic) IBOutlet UILabel  *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel  *subtitleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (void)addButton:(NSInteger)buttonNumber;
- (IBAction)doAThing;
@property (weak, nonatomic) IBOutlet UIButton *mediaButton1;
@property (weak, nonatomic) IBOutlet UIButton *mediaButton2;

@end
