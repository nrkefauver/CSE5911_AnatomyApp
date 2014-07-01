//
//  IndexAllViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "IndexAllViewController.h"
#import "ExpandingCell.h"

//COLLAPSIBLE CODE
#define kTableHeaderHeight 80.0f
#define kTableRowHeight 40.0f


@interface IndexAllViewController () {
    EMAccordionTableViewController *emTV;

}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IndexAllViewController
NSArray *searchResults;
static NSIndexPath *globalIndexPath;
static UITableView *globalTableView;
static bool tableViewIsCreated = false;
//static bool sectionOpen[4]={NO,NO,NO,NO};


//COLLAPSIBLE TABLE CODE
NSMutableArray *dataSection01;
NSMutableArray *dataSection02;
NSMutableArray *dataSection03;
NSMutableArray *dataSection04;

NSArray *sections;
CGFloat origin;

- (void) viewDidAppear:(BOOL)animated {
    // Setup the EMAccordionTableViewController
    origin = 20.0f;
    if ([[UIDevice currentDevice].model hasPrefix:@"iPad"])
        origin = 100.0f;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin, origin, self.view.bounds.size.width - origin*2, self.view.bounds.size.height - origin*2) style:UITableViewStylePlain];
    [tableView setSectionHeaderHeight:kTableHeaderHeight];
    /*
     ... set here some other tableView properties ...
     */
    
    // Setup the EMAccordionTableViewController
    emTV = [[EMAccordionTableViewController alloc] initWithTable:tableView];
    [emTV setDelegate:self];
    
    [emTV setClosedSectionIcon:[UIImage imageNamed:@"closedIcon"]];
    [emTV setOpenedSectionIcon:[UIImage imageNamed:@"openedIcon"]];
    
    
    searchArray = [[NSMutableArray alloc] init];
    searchSubtitles = [[NSMutableArray alloc] init];
    searchText = [[NSMutableArray alloc] init];
    
    
    
    

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"plist"];
    
    //Iterates through entire terms list and creates array containing all the Neuroanatomy (array) terms
    NSArray *terms = [[NSArray alloc] initWithContentsOfFile:path];
    
    //Create temp array for keys
    NSMutableArray *tempNames = [[NSMutableArray alloc] init];
    NSMutableArray *tempDefs = [[NSMutableArray alloc] init];
    for (int i=0; i< 141; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:1] isEqualToString:@""]) {
                [nTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:1] ];
            }
        }
    }
    
    //Create Dictionary for terms and their definitions
    NSDictionary *dictN= [[NSDictionary alloc] initWithObjects:tempDefs forKeys:tempNames];
    
    
    //Create alphabetical list of definition names
    NSArray * sortedNKeys = [[dictN allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedNValues = [dictN objectsForKeys: sortedNKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    nTitleArray = sortedNKeys;
    
    //Adds to overall list of definitions for searching
    [searchArray addObjectsFromArray:sortedNKeys];
    
    //Creates an array of definition names
    subtitleNArray = sortedNKeys;
    [searchSubtitles addObjectsFromArray:subtitleNArray];
    
    //Creates array of definitions
    textNArray = sortedNValues;
    [searchText addObjectsFromArray:textNArray];
    
    // Setup some test data
    dataSection01 = nTitleArray;
    
    
    

    //Create temp array for keys
    [tempNames removeAllObjects];
    [tempDefs removeAllObjects];
    for (int i=0; i< 141; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:2] isEqualToString:@""]) {
                [hTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:2] ];
            }
        }
    }
    
    //Create Dictionary for terms and their definitions
    NSDictionary *dictH= [[NSDictionary alloc] initWithObjects:tempDefs forKeys:tempNames];
    
    
    //Create alphabetical list of definition names
    NSArray * sortedHKeys = [[dictH allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedHValues = [dictH objectsForKeys: sortedHKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    hTitleArray = sortedHKeys;

    //Adds to overall list of definitions for searching
    [searchArray addObjectsFromArray:sortedHKeys];
    
    //Creates an array of definition names
    subtitleHArray = sortedHKeys;
    [searchSubtitles addObjectsFromArray:sortedHKeys];
    
    //Creates array of definitions
    textHArray = sortedHValues;
    [searchText addObjectsFromArray:sortedHValues];

    dataSection02 = hTitleArray;
    
   
  
    //Create temp array for keys
    [tempNames removeAllObjects];
    [tempDefs removeAllObjects];
    for (int i=0; i< 141; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:3] isEqualToString:@""]) {
                [eTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
            }
        }
    }
    
    //Create Dictionary for terms and their definitions
    NSDictionary *dictE= [[NSDictionary alloc] initWithObjects:tempDefs forKeys:tempNames];
    
    
    //Create alphabetical list of definition names
    NSArray * sortedEKeys = [[dictE allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedEValues = [dictE objectsForKeys: sortedEKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    eTitleArray = sortedEKeys;

    //Adds to overall list of definitions for searching
    [searchArray addObjectsFromArray:sortedEKeys];
    
    //Creates an array of definition names
    subtitleEArray = sortedEKeys;
    [searchSubtitles addObjectsFromArray:sortedEKeys];
    
    //Creates array of definitions
    textEArray = sortedEValues;
    [searchText addObjectsFromArray:sortedEValues];
    
    dataSection03 = eTitleArray;
    
    
    //Create temp array for keys
    [tempNames removeAllObjects];
    [tempDefs removeAllObjects];
    for (int i=0; i< 141; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:4] isEqualToString:@""]) {
                [gTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
            }
        }
    }
    
    //Create Dictionary for terms and their definitions
    NSDictionary *dictG= [[NSDictionary alloc] initWithObjects:tempDefs forKeys:tempNames];
    
    
    //Create alphabetical list of definition names
    NSArray * sortedGKeys = [[dictG allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedGValues = [dictG objectsForKeys: sortedGKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    gTitleArray = sortedGKeys;

    //Adds to overall list of definitions for searching
    [searchArray addObjectsFromArray:sortedGKeys];
    
    //Creates an array of definition names
    subtitleGArray = sortedGKeys;
    [searchSubtitles addObjectsFromArray:sortedGKeys];
    
    //Creates array of definitions
    textGArray = sortedGValues;
    [searchText addObjectsFromArray:sortedGValues];
    
    dataSection04 = gTitleArray;

    //
    
    // Section graphics
    UIColor *sectionsColor = [UIColor blackColor];
    UIColor *sectionTitleColor = [UIColor whiteColor];
    UIFont *sectionTitleFont = [UIFont fontWithName:@"Georgia-Bold" size:24.0f];
    
    // Add the sections to the controller
    EMAccordionSection *section01 = [[EMAccordionSection alloc] init];
    [section01 setBackgroundColor:sectionsColor];
    [section01 setItems:dataSection01];
    [section01 setTitle:@"Neuroanatomy"];
    [section01 setTitleFont:[UIFont fontWithName:@"Georgia-Bold" size:24.0f]];
    [section01 setTitleColor:sectionTitleColor];
    [emTV addAccordionSection:section01];
    
    EMAccordionSection *section02 = [[EMAccordionSection alloc] init];
    [section02 setBackgroundColor:sectionsColor];
    [section02 setItems:dataSection02];
    [section02 setTitle:@"Histology"];
    [section02 setTitleColor:sectionTitleColor];
    [section02 setTitleFont:sectionTitleFont];
    [emTV addAccordionSection:section02];
    
    EMAccordionSection *section03 = [[EMAccordionSection alloc] init];
    [section03 setBackgroundColor:sectionsColor];
    [section03 setItems:dataSection03];
    [section03 setTitle:@"Embryology"];
    [section03 setTitleColor:sectionTitleColor];
    [section03 setTitleFont:sectionTitleFont];
    [emTV addAccordionSection:section03];
    
    EMAccordionSection *section04 = [[EMAccordionSection alloc] init];
    [section04 setBackgroundColor:sectionsColor];
    [section04 setItems:dataSection04];
    [section04 setTitle:@"Gross Anatomy"];
    [section04 setTitleColor:sectionTitleColor];
    [section04 setTitleFont:sectionTitleFont];
    [emTV addAccordionSection:section04];

    sections = [[NSArray alloc] initWithObjects:section01,section02,section03, section04, nil];
    
    [self.view addSubview:emTV.tableView];
}

- (NSMutableArray *) dataFromIndexPath: (NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return dataSection01;
    
    return NULL;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //Testing expandable cells code
    //self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return searchArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        // Set preselected term in the segmented control (tag 1000):
        UIView *nibView = [nib objectAtIndex:0];
        UISegmentedControl *segmentedControl = (UISegmentedControl*)[nibView viewWithTag:1000];
        
        // in Neuro
        if(indexPath.section==0)
        {
            [segmentedControl setSelectedSegmentIndex:0];
        }
        // in Histo
        else if(indexPath.section==1)
        {
            [segmentedControl setSelectedSegmentIndex:1];
        }
        // in Embryo
        else if(indexPath.section==2)
        {
            [segmentedControl setSelectedSegmentIndex:2];
        }
        // in Gross
        else if(indexPath.section==3)
        {
            [segmentedControl setSelectedSegmentIndex:3];
        }
    }
    
//    // Close all sections except current one
//    sectionOpen[0]=NO;
//	sectionOpen[1]=NO;
//	sectionOpen[2]=NO;
//	sectionOpen[3]=NO;
//    sectionOpen[indexPath.row]=YES;
//    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    // Populate terms and definitions
    NSString *term;
    int pos = indexPath.row;
    if (pos<= searchArray.count) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            term =[searchResults objectAtIndex:indexPath.row];
            cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
            cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
            int pos = [searchSubtitles indexOfObject:[searchResults objectAtIndex:indexPath.row]];
            cell.textLabel.text = [searchText objectAtIndex:pos];
        } else if (indexPath.section==0) {
            cell.titleLabel.text = [nTitleArray objectAtIndex:indexPath.row];
            cell.subtitleLabel.text = [subtitleNArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [textNArray objectAtIndex:indexPath.row];
        } else if (indexPath.section==1) {
        cell.titleLabel.text = [hTitleArray objectAtIndex:indexPath.row];
        cell.subtitleLabel.text = [subtitleHArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [textHArray objectAtIndex:indexPath.row];
        } else if (indexPath.section==2) {
        cell.titleLabel.text = [eTitleArray objectAtIndex:indexPath.row];
        cell.subtitleLabel.text = [subtitleEArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [textEArray objectAtIndex:indexPath.row];
        } else if (indexPath.section == 3) {
        cell.titleLabel.text = [gTitleArray objectAtIndex:indexPath.row];
        cell.subtitleLabel.text = [subtitleGArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [textGArray objectAtIndex:indexPath.row];
        }
    
    }
    cell.textLabel.layer.borderWidth = 2.0f;
    cell.textLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.textLabel.layer.cornerRadius = 8.0f;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:14.0];
    cell.clipsToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedIndex == indexPath.row) {
        return 350;
    } else {
        return 36;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    // Access expandingCell's segmented controller
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
    cell = [nib objectAtIndex:0];
    // Set preselected term in the segmented control (tag 1000):
    UIView *nibView = [nib objectAtIndex:0];
    UISegmentedControl *segmentedControl = (UISegmentedControl*)[nibView viewWithTag:1000];
    // in Neuro
    if(indexPath.section==0){
        [segmentedControl setSelectedSegmentIndex:0];
    }
    // in Histo
    else if(indexPath.section==1){
        [segmentedControl setSelectedSegmentIndex:1];
    }
    // in Embryo
    else if(indexPath.section==2){
        [segmentedControl setSelectedSegmentIndex:2];
    }
    // in Gross
    else if(indexPath.section==3){
        [segmentedControl setSelectedSegmentIndex:3];
    }
    
    // Track indexPath and table view
    globalIndexPath = indexPath;
    globalTableView = tableView;
    tableViewIsCreated = true;
    
    //User taps new row with none expanded
    if (selectedIndex == -1) {
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    //User taps expanded row
    else if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    //User taps different row
    else if (selectedIndex != -1) {
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith [c] %@", searchText];
    searchResults = [searchArray filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
   //controller.displaysSearchBarInNavigationBar = YES;

    [controller.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                                        selectedScopeButtonIndex]]];
    // close any open cells
    selectedIndex = -1;
    
    return YES;
}

//// If cells have been opened, close them when starting search
//- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
//{
//    if (tableViewIsCreated)
//    {
//        selectedIndex = -1;
//        [globalTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:globalIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//// Don't let searchDisplayControllerWillBeginSearch reload globalTableView if it hasn't been established
//- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
//{
//    tableViewIsCreated = false;
//}

// Prevent other indices from crashing if "cancel" was hit while results were being displayed
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)@""];
}

//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([emDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
//        return [emDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
//    else
//        [NSException raise:@"The delegate doesn't respond tableView:didSelectRowAtIndexPath:" format:@"The delegate doesn't respond tableView:didSelectRowAtIndexPath:"];
//}

@end
