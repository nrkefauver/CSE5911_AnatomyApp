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
    NSMutableArray *titleArray;
    NSMutableArray *subtitleArray;
    NSMutableArray *textArray;
    NSMutableDictionary *masterDictionary;

}

- (IBAction)switchSelectedDiscipline:(UISegmentedControl *)segmentedControl;

enum selectedDisciplineEnum
{
    neuro,
    histo,
    embryo,
    gross
};

@end
