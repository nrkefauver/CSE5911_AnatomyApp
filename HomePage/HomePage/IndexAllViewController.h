//
//  IndexAllViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAccordionTableViewController.h"
@interface IndexAllViewController : UIViewController <EMAccordionTableDelegate, UITableViewDataSource, UISearchDisplayDelegate>
{
    int selectedIndex;
    NSMutableArray *searchArray;
    NSMutableArray *searchSubtitles;
    NSMutableArray *searchText;
    NSMutableDictionary *masterDictionary;
    
    NSMutableArray *nTitleArray;
    NSMutableArray  *nArray;
    NSMutableArray  *subtitleNArray;
    NSMutableArray  *textNArray;
    
    NSMutableArray  *gTitleArray;
    NSMutableArray  *gArray;
    NSMutableArray  *subtitleGArray;
    NSMutableArray  *textGArray;
    
    NSMutableArray  *hTitleArray;
    NSMutableArray  *hArray;
    NSMutableArray  *subtitleHArray;
    NSMutableArray  *textHArray;
    
    NSMutableArray  *eTitleArray;
    NSMutableArray  *eArray;
    NSMutableArray  *subtitleEArray;
    NSMutableArray  *textEArray;
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
