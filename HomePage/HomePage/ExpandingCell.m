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

- (void)addButton:(NSInteger)buttonNumber
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button addTarget:self
               action:@selector(doAThing)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Does this matter?" forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"home.png"];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = CGRectMake(220.0, 100.0, 45.0, 45.0);
    //[self.view addSubview:button];  <--------------------- Don't know why/how to get 'view'
    [self addSubview:button];
    
    
//    // Create button at location based on buttonNumber
//    switch (buttonNumber) {
//        {case 0:
//            [button addTarget:self
//                       action:@selector(doAThing)
//             forControlEvents:UIControlEventTouchUpInside];
//            UIImage *img = [UIImage imageNamed:@"home.png"];
//            [button setImage:img forState:UIControlStateNormal];
//            button.frame = CGRectMake(20.0, 285.0, 45.0, 45.0);
//            break;}
//            
//        {case 1:
//            
//            break;}
//        {default:
//            break;}
//    }
    
    
}

- (void) doAThing
{
    NSLog(@"Expanding Cell programmatic button was clicked");
}

@end
