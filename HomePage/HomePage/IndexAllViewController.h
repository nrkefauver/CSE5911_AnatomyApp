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
    
    NSArray *nTitleArray;
    NSArray *nArray;
    NSArray *subtitleNArray;
    NSArray *textNArray;
    
    NSArray *gTitleArray;
    NSArray *gArray;
    NSArray *subtitleGArray;
    NSArray *textGArray;
    
    NSArray *hTitleArray;
    NSArray *hArray;
    NSArray *subtitleHArray;
    NSArray *textHArray;
    
    NSArray *eTitleArray;
    NSArray *eArray;
    NSArray *subtitleEArray;
    NSArray *textEArray;
}



@end
