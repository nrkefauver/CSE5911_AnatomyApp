//
//  NeuroTractsViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 7/21/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeuroTractsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *afferentTableView;
@property (weak, nonatomic) IBOutlet UITableView *efferentTableView;

@end
