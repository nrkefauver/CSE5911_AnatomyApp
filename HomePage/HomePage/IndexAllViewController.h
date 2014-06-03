//
//  IndexAllViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexAllViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    int selectedIndex;
    NSMutableArray *titleArray;
    NSArray *subtitleArray;
    NSArray *textArray;
    
    
    
}

@end
