//
//  PopoverTableViewCell.h
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/26/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textLabel;

@end
