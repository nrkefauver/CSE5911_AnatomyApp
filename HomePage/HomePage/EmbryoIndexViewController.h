//
//  EmbryoIndexViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 6/10/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface EmbryoIndexViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate> {
    
    int selectedIndex;
    NSArray *titleArray;
    NSArray *subtitleArray;
    NSArray *textArray;
}

@end
