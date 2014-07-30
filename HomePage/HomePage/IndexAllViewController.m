//
//  IndexAllViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "IndexAllViewController.h"
#import "NeuroViewController.h"
#import "NeuroTractsViewController.h"
#import "HistoSlide1ViewController.h"
#import "EmbryoViewController.h"
#import "EmbryoAnimationsListViewController.h"
#import "Gross3DModelViewController.h"
#import "GrossViewController.h"
#import "GrossVideoListViewController.h"
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
static NSInteger lastCellSection;
static bool afterCellReset = false;
static UITableView *globalTableView;
static int nonsearchSelectedIndex;
static bool afterSearch = false;
static enum selectedDisciplineEnum selectedDiscipline = neuro;
static int NeuroMedia = 5; //Position in property list for all Neuro Media options
static int HistoMedia = 6; //Position in property list for all Histo Media options
static int EmbryoMedia = 7; //Position in property list for all Embryo Media options
static int GrossMedia = 8; //Position in property list for all Gross Media options
static NSString *partName; //Name of term to display with Popover window in Gross Home
static NSString *videoName; //Name of video to play in Embryo Animations List or Gross Video List
static bool mediaButtonSegue = false; //Tracks if a segue is triggered by a media button or not


//COLLAPSIBLE TABLE CODE
NSMutableArray *dataSection01;
NSMutableArray *dataSection02;
NSMutableArray *dataSection03;
NSMutableArray *dataSection04;

NSArray *sections;
CGFloat origin;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table Contents
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
    
    //Initialize the dictionary that will contain all the definition options
    masterDictionary = [[NSMutableDictionary alloc] init];
    mediaDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"plist"];
    
    //Iterates through entire terms list and creates array containing all the Neuroanatomy (array) terms
    NSArray *terms = [[NSArray alloc] initWithContentsOfFile:path];
    
    //Create temp array for keys
    NSMutableArray *tempNames = [[NSMutableArray alloc] init];
    NSMutableArray *tempDefs = [[NSMutableArray alloc] init];
    NSMutableArray *defOptions = [[NSMutableArray alloc] init];
    NSMutableArray *mediaOptions = [[NSMutableArray alloc] init];
    
    for (int i=0; i< 140; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:1] isEqualToString:@""]) {
                [nTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:1] ];

                //Creates array of all the possible definitions for each term
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:1] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:2] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
                [defOptions addObject:temp];
                
                //Creates array of all the media arrays for each term
                NSMutableArray *tempMedia = [[NSMutableArray alloc]init];
                [tempMedia addObject:[[terms objectAtIndex:i] objectAtIndex:NeuroMedia]] ;
                [tempMedia addObject:[[terms objectAtIndex:i] objectAtIndex:HistoMedia] ];
                [tempMedia addObject:[[terms objectAtIndex:i] objectAtIndex:EmbryoMedia] ];
                [tempMedia addObject:[[terms objectAtIndex:i] objectAtIndex:GrossMedia]];
                [mediaOptions addObject:tempMedia];
            }
        }
    }
    
    //Adds all Neuro terms and their designated definitions to the overall dictionary
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];
    
    //Adds all Neuro terms and their designated media to the media dictionary
    NSDictionary *mediaDict = [[NSDictionary alloc] initWithObjects:mediaOptions forKeys:tempNames];
    [mediaDictionary addEntriesFromDictionary:mediaDict];
    
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
    [defOptions removeAllObjects];
    for (int i=0; i< 140; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:2] isEqualToString:@""]) {
                [hTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:2] ];
                
                
                //Creates array of all the possible definitions for each term
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:1] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:2] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
                [defOptions addObject:temp];
            }
        }
    }
    
    //Adds all Histology terms and their designated definitions to the overall dictionary
    tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];
    
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
    [defOptions removeAllObjects];
    for (int i=0; i< 140; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:3] isEqualToString:@""]) {
                [eTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
                
                //Creates array of all the possible definitions for each term
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:1] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:2] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
                [defOptions addObject:temp];
            }
        }
    }
    
    //Adds all Embryology terms and their designated definitions to the overall dictionary
    tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];

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
    [defOptions removeAllObjects];
    for (int i=0; i< 140; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:4] isEqualToString:@""]) {
                [gTitleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
                
                //Creates array of all the possible definitions for each term
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:1] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:2] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
                [temp addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
                [defOptions addObject:temp];
            }
        }
    }
    
    //Adds all Gross terms and their designated definitions to the overall dictionary
    tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];

    
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
    
    emTV.tableView.tag = 100;
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
    // Access expanding cell
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
//    if (lastCellSection != indexPath.section)
//    {
//        selectedIndex = -1;
//        lastCellSection = indexPath.section;
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
    
    NSString *term;
    switch (indexPath.section)
    {
            
        case 0: // In Neuro Section
            if (selectedDiscipline == neuro)
            {
                if (indexPath.row <= searchArray.count) {
                    if (tableView == self.searchDisplayController.searchResultsTableView) {
                        term =[searchResults objectAtIndex:indexPath.row];
                        cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    } else {
                        cell.subtitleLabel.text = [subtitleNArray objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    }
                }
            }
            else if (selectedDiscipline == histo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                    
                } else {
                    cell.subtitleLabel.text = [subtitleNArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                }
            }
            else if (selectedDiscipline == embryo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                } else {
                    cell.subtitleLabel.text = [subtitleNArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                }
            }
            else{
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                } else {
                    cell.subtitleLabel.text = [subtitleNArray objectAtIndex:indexPath.row];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                }
            }
        break;
            
        case 1: // In Histo Section
            if (selectedDiscipline == neuro)
            {
                if (indexPath.row <= searchArray.count) {
                    if (tableView == self.searchDisplayController.searchResultsTableView) {
                        term =[searchResults objectAtIndex:indexPath.row];
                        cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    } else {
                        cell.subtitleLabel.text = [subtitleHArray objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    }
                }
            }
            else if (selectedDiscipline == histo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                    
                } else {
                    cell.subtitleLabel.text = [subtitleHArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                }
            }
            else if (selectedDiscipline == embryo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                } else {
                    cell.subtitleLabel.text = [subtitleHArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                }
            }
            else{
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                } else {
                    cell.subtitleLabel.text = [subtitleHArray objectAtIndex:indexPath.row];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                }
            }
        break;
            
        case 2: // In Embryo Section
            if (selectedDiscipline == neuro)
            {
                if (indexPath.row <= searchArray.count) {
                    if (tableView == self.searchDisplayController.searchResultsTableView) {
                        term =[searchResults objectAtIndex:indexPath.row];
                        cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    } else {
                        cell.subtitleLabel.text = [subtitleEArray objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    }
                }
            }
            else if (selectedDiscipline == histo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                    
                } else {
                    cell.subtitleLabel.text = [subtitleEArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                }
            }
            else if (selectedDiscipline == embryo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                } else {
                    cell.subtitleLabel.text = [subtitleEArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                }
            }
            else{
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                } else {
                    cell.subtitleLabel.text = [subtitleEArray objectAtIndex:indexPath.row];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                }
            }
        break;
            
        case 3: // In Gross Section
            if (selectedDiscipline == neuro)
            {
                if (indexPath.row <= searchArray.count) {
                    if (tableView == self.searchDisplayController.searchResultsTableView) {
                        term =[searchResults objectAtIndex:indexPath.row];
                        cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    } else {
                        cell.subtitleLabel.text = [subtitleGArray objectAtIndex:indexPath.row];
                        cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
                    }
                }
            }
            else if (selectedDiscipline == histo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                    
                } else {
                    cell.subtitleLabel.text = [subtitleGArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1];
                }
            }
            else if (selectedDiscipline == embryo){
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                } else {
                    cell.subtitleLabel.text = [subtitleGArray objectAtIndex:indexPath.row];
                    cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2];
                }
            }
            else{
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    term =[searchResults objectAtIndex:indexPath.row];
                    cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                    //int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                } else {
                    cell.subtitleLabel.text = [subtitleGArray objectAtIndex:indexPath.row];
                    cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
                }
            }
        break;
    }
    
    
    // Set segmentedController and Media Buttons
    UIView *nibView = [nib objectAtIndex:0];
    UISegmentedControl *segmentedControl = (UISegmentedControl*)[nibView viewWithTag:1000];
    UIButton *button1 = (UIButton*)[nibView viewWithTag:10];
    UIButton *button2 = (UIButton*)[nibView viewWithTag:20];
    UIButton *button3 = (UIButton*)[nibView viewWithTag:30];
    
    //Disables user interaction if a segment does not have a definition for the current term
    for (int i=0;i<4;i++) {
        if([[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:i] isEqualToString:@""]) {
            [segmentedControl setEnabled:NO forSegmentAtIndex:i];
        }
    }
    // Set media buttons based on the selected discipline
    switch(selectedDiscipline)
    {
        {case 0: //Neuro
            // Set the segmented control to Neuro
            [segmentedControl setSelectedSegmentIndex:0];
            
            // Used for setting the media buttons from left to right
            bool button1IsTaken = false;
            
            // Set button for 2D Image if applicable
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0]objectAtIndex:1]isEqualToString:@""])
            {
                // Set videos
                UIImage* button1Image = [UIImage imageNamed:@"2D Image Media Button"];
                [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                
                // Set actions
                [button1 addTarget:self
                            action:@selector(neuro2DButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
                
                button1IsTaken = true;
            }
            
            // Set button for Animation if applicable
            if (button1IsTaken)
            {
                if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0]objectAtIndex:3]isEqualToString:@""])
                {
                    // Set animation
                    UIImage* button2Image = [UIImage imageNamed:@"Animation Media Button"];
                    [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button2 addTarget:self
                                action:@selector(neuroAnimationButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information for actions
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0]objectAtIndex:3];
                }
            }
            else // Button 1 is not taken
            {
                if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0] objectAtIndex:3]isEqualToString:@""])
                {
                    // Set videos
                    UIImage* button1Image = [UIImage imageNamed:@"Animation Media Button"];
                    [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button1 addTarget:self
                                action:@selector(neuroAnimationButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information for actions
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0]objectAtIndex:3];
                }
            }
            
            // If there is no media, display "None"
            if (!button1IsTaken)
            {
                [button1 setTitle:@"None" forState:UIControlStateNormal];
            }
            break;}
            
        {case 1: //Histo
            // Set the segmented control to Histo
            [segmentedControl setSelectedSegmentIndex:1];
            
            bool button1IsTaken = false;
            
            // Set button for 3D Model if applicable
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:1]objectAtIndex:1]isEqualToString:@""])
            {
                // Set videos
                UIImage* button1Image = [UIImage imageNamed:@"2D Image Media Button"];
                [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                
                // Set actions
                [button1 addTarget:self
                            action:@selector(histo2DButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
                
                button1IsTaken = true;
            }
            
            // If there is no media, display "None"
            if (!button1IsTaken)
            {
                [button1 setTitle:@"None" forState:UIControlStateNormal];
            }
            break;}
            
        {case 2: //Embryo
            // Set the segmented control to Embryo
            [segmentedControl setSelectedSegmentIndex:2];
            
            // Used for setting the media buttons from left to right
            bool button1IsTaken = false;
            
            // Set button for 2D Image if applicable
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2]objectAtIndex:1]isEqualToString:@""])
            {
                // Set videos
                UIImage* button1Image = [UIImage imageNamed:@"2D Image Media Button"];
                [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                
                // Set actions
                [button1 addTarget:self
                            action:@selector(embryo2DButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
                
                button1IsTaken = true;
            }
            
            // Set button for Animation if applicable
            if (button1IsTaken)
            {
                if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2]objectAtIndex:3]isEqualToString:@""])
                {
                    // Set animation
                    UIImage* button2Image = [UIImage imageNamed:@"Animation Media Button"];
                    [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button2 addTarget:self
                                action:@selector(embryoAnimationButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information for actions
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2]objectAtIndex:3];
                }
            }
            else // Button 1 is not taken
            {
                if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2] objectAtIndex:3]isEqualToString:@""])
                {
                    // Set videos
                    UIImage* button1Image = [UIImage imageNamed:@"Animation Media Button"];
                    [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button1 addTarget:self
                                action:@selector(embryoAnimationButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information for actions
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2]objectAtIndex:3];
                }
            }
            
            // If there is no media, display "None"
            if (!button1IsTaken)
            {
                [button1 setTitle:@"None" forState:UIControlStateNormal];
            }
            break;}
            
        {case 3: //Gross
            // Set segmented control to Gross
            [segmentedControl setSelectedSegmentIndex:3];
            
            // Used for setting the media buttons from left to right
            bool button1IsTaken = false;
            bool button2IsTaken = false;
            
            // Set button for 3D Model if applicable
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:0]isEqualToString:@""])
            {
                // Set videos
                UIImage* button1Image = [UIImage imageNamed:@"3D Model Media Button"];
                [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                
                // Set actions
                [button1 addTarget:self
                            action:@selector(gross3DButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
                
                button1IsTaken = true;
            }
            
            //Set button for 2D Image if applicable
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:1]isEqualToString:@""])
            {
                if (button1IsTaken)
                {
                    // Set videos
                    UIImage* button2Image = [UIImage imageNamed:@"2D Image Media Button"];
                    [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button2 addTarget:self
                                action:@selector(gross2DButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information to be passed
                    partName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:1];
                    
                    button2IsTaken = true;
                }
                else // Button 1 is not taken
                {
                    // Set videos
                    UIImage* button1Image = [UIImage imageNamed:@"2D Image Media Button"];
                    [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button1 addTarget:self
                                action:@selector(gross2DButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information to be passed
                    partName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:1];
                    
                    button1IsTaken = true;
                }
            }
            
            //Set button for Video if applicable
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:2]isEqualToString:@""])
            {
                if ((button1IsTaken)&&(button2IsTaken))
                {
                    
                    // Set videos
                    UIImage* button3Image = [UIImage imageNamed:@"Video Media Button"];
                    [button3 setBackgroundImage:button3Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button3 addTarget:self
                                action:@selector(grossVideoButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information to be passed
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:2];
                }
                else if (button1IsTaken)
                {
                    
                    // Set videos
                    UIImage* button2Image = [UIImage imageNamed:@"Video Media Button"];
                    [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button2 addTarget:self
                                action:@selector(grossVideoButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information to be passed
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:2];
                    
                }
                else
                {
                    
                    // Set videos
                    UIImage* button1Image = [UIImage imageNamed:@"Video Media Button"];
                    [button1 setBackgroundImage:button1Image forState:UIControlStateNormal];
                    
                    // Set actions
                    [button1 addTarget:self
                                action:@selector(grossVideoButtonPressed)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                    // Set information to be passed
                    videoName = [[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3]objectAtIndex:2];
                }
            }
            
            // If there is no media, display "None"
            if (!button1IsTaken)
            {
                [button1 setTitle:@"None" forState:UIControlStateNormal];
            }
            break;}
    }
    
    //Formatting for definition text view
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
        selectedDiscipline = neuro;
    }
    // in Histo
    else if(indexPath.section==1){
        selectedDiscipline = histo;
    }
    // in Embryo
    else if(indexPath.section==2){
        selectedDiscipline = embryo;
    }
    // in Gross
    else if(indexPath.section==3){
        selectedDiscipline = gross;
    }
    
    // Track indexPath and table view
    globalIndexPath = indexPath;
    globalTableView = tableView;
    
    // If immediately after a search, base action off of index stored in nonsearchSelectedIndex
    if (afterSearch)
    {
        afterSearch = false;
        
        //User taps new row with none expanded
        if (nonsearchSelectedIndex == -1) {
            selectedIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        //User taps expanded row
        else if (nonsearchSelectedIndex == indexPath.row) {
            selectedIndex = -1;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        //User taps different row
        else if (nonsearchSelectedIndex != -1) {
            selectedIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    // Not immediately after a search
    else
    {
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
}

- (IBAction)switchSelectedDiscipline:(UISegmentedControl *)segmentedControl
{
    //Switches definitions and media based on selected subdiscipline
    switch(segmentedControl.selectedSegmentIndex)
    {
        case 0:
            selectedDiscipline = neuro;
            break;
        case 1:
            selectedDiscipline = histo;
            break;
        case 2:
            selectedDiscipline = embryo;
            break;
        case 3:
            selectedDiscipline = gross;
            break;
    }
    
    [globalTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:globalIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Media Button Actions
- (void) neuro2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToNeuroHomeSegue" sender:self];
}

- (void) neuroAnimationButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToNeuroTractsSegue" sender:self];
}

- (void) histo2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToHistoSlideSegue" sender:self];
}

- (void) embryo2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToEmbryoHomeSegue" sender:self];
}

- (void) embryoAnimationButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToEmbryoAnimationListSegue" sender:self];
}

- (void) gross3DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToGross3DSegue" sender:self];
}

- (void) gross2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToGrossHomeSegue" sender:self];
}

- (void) grossVideoButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"IndexAllToGrossVideoListSegue" sender:self];
}

// Pass information if segue is triggered by a media button
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //NeuroViewController* neuroHomeVC;
    NeuroTractsViewController* neuroTractsVC;
    //HistoSlide1ViewController* histoSlideVC;
    //EmbryoViewController* embryoHomeVC;
    EmbryoAnimationsListViewController* embryoAnimationVC;
    //Gross3DModelViewController* gross3DVC;
    GrossViewController* grossHomeVC;
    GrossVideoListViewController* grossVideoVC;
    
    if (mediaButtonSegue)
    {
        // Neuro 2D
        //if([segue.identifier isEqualToString:@"IndexAllToNeuroHomeSegue"])
        //{
        //    neuroHomeVC = segue.destinationViewController;
              //Set passed info
        
        //  When this code is written, change the following "if" to an "else if"
        //}
        // Neuro Animation
        if([segue.identifier isEqualToString:@"IndexAllToNeuroTractsSegue"])
        {
            neuroTractsVC = segue.destinationViewController;
            neuroTractsVC.startUpVideoName = videoName;
        }
        // Histo 2D
        //else if([segue.identifier isEqualToString:@"IndexAllToHistoSlideSegue"])
        //{
        //    histoSlideVC = segue.destinationViewController;
              //Set passed info
        //}
        // Embryo 2D
        //else if([segue.identifier isEqualToString:@"IndexAllToEmbryoHomeSegue"])
        //{
        //    embryoHomeVC = segue.destinationViewController;
              //Set passed info
        //}
        // Embryo Animation
        else if([segue.identifier isEqualToString:@"IndexAllToEmbryoAnimationListSegue"])
        {
            embryoAnimationVC = segue.destinationViewController;
            embryoAnimationVC.startUpVideoName = videoName;
        }
        // Gross 3D
        //else if([segue.identifier isEqualToString:@"IndexAllToGross3DSegue"])
        //{
        //    gross3DVC = segue.destinationViewController;
              //Set passed info
        //}
        // Gross 2D
        else if([segue.identifier isEqualToString:@"IndexAllToGrossHomeSegue"])
        {
            grossHomeVC = segue.destinationViewController;
            grossHomeVC.initialPopupName = partName;
        }
        // Gross Video
        else if([segue.identifier isEqualToString:@"IndexAllToGrossVideoListSegue"])
        {
            grossVideoVC = segue.destinationViewController;
            grossVideoVC.startUpVideoName = videoName;
        }
    }
}

#pragma mark - Search Bar
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

// If cells have been opened, close them when starting search
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    nonsearchSelectedIndex = selectedIndex;
}

// Don't let searchDisplayControllerWillBeginSearch reload globalTableView if it hasn't been established
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    afterSearch = true;
}

// Prevent other indices from crashing if "cancel" was hit while results were being displayed
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)@""];
}



@end
