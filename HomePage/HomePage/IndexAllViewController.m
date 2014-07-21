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
static NSInteger lastCellSection;
static bool afterCellReset = false;
static UITableView *globalTableView;
static int nonsearchSelectedIndex;
static bool afterSearch = false;
static enum selectedDisciplineEnum selectedDiscipline = neuro;


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
    
    //Initialize the dictionary that will contain all the definition options
    masterDictionary = [[NSMutableDictionary alloc] init];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"plist"];
    
    //Iterates through entire terms list and creates array containing all the Neuroanatomy (array) terms
    NSArray *terms = [[NSArray alloc] initWithContentsOfFile:path];
    
    //Create temp array for keys
    NSMutableArray *tempNames = [[NSMutableArray alloc] init];
    NSMutableArray *tempDefs = [[NSMutableArray alloc] init];
    NSMutableArray *defOptions = [[NSMutableArray alloc] init];
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
            }
        }
    }
    
    //Adds all Neuro terms and their designated definitions to the overall dictionary
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];
    
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
    switch (indexPath.section) {
            
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
    
    //Disables user interaction if a segment does not have a definition for the current term
    for (int i=0;i<4;i++) {
        if([[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:i] isEqualToString:@""]) {
            [segmentedControl setEnabled:NO forSegmentAtIndex:i];
        }
    }
    
    switch(selectedDiscipline)
    {
        {case 0: //Neuro
            [segmentedControl setSelectedSegmentIndex:0];
            
            [button1 setTitle:@"Neuro Button!" forState:UIControlStateNormal];
            [button2 setTitle:@"Neuro Button!" forState:UIControlStateNormal];
            
            UIImage* button2Image = [UIImage imageNamed:@"Letter N"];
            [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
            [button2 addTarget:self
                        action:@selector(doAThing)
              forControlEvents:UIControlEventTouchUpInside];
            break;}
        {case 1: //Histo
            [segmentedControl setSelectedSegmentIndex:1];
            
            [button1 setTitle:@"Histo Button!" forState:UIControlStateNormal];
            [button2 setTitle:@"Histo Button!" forState:UIControlStateNormal];
            
            UIImage* button2Image = [UIImage imageNamed:@"Letter H"];
            [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
            [button2 addTarget:self
                        action:@selector(doAThing)
              forControlEvents:UIControlEventTouchUpInside];
            break;}
        {case 2: //Embryo
            [segmentedControl setSelectedSegmentIndex:2];
            
            [button1 setTitle:@"Embryo Button!" forState:UIControlStateNormal];
            [button2 setTitle:@"" forState:UIControlStateNormal];
            
            [button2 setBackgroundImage:nil forState:UIControlStateNormal];
            //            [button1 addTarget:self
            //                        action:@selector(doADifferentThing)
            //              forControlEvents:UIControlEventTouchUpInside];
            break;}
        {case 3: //Gross
            [segmentedControl setSelectedSegmentIndex:3];
            
            [button1 setTitle:@"Gross Button!" forState:UIControlStateNormal];
            [button2 setTitle:@"Gross Button!" forState:UIControlStateNormal];
            //[button2 setBackgroundImage:(UIImage*)@"Gross.png" forState:UIControlStateNormal];
            
            UIImage* button2Image = [UIImage imageNamed:@"Letter G"];
            [button2 setBackgroundImage:button2Image forState:UIControlStateNormal];
            [button2 addTarget:self
                        action:@selector(doADifferentThing)
              forControlEvents:UIControlEventTouchUpInside];
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

#pragma Media Button Methods

- (void) doAThing
{
    self.title = @"works";
    //[self performSegueWithIdentifier:@"NeuroIndexToNeuroHomeSegue" sender:self];
}

- (void) doADifferentThing
{
    self.title = @"This is different!";
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    NeuroViewController* destViewController = segue.destinationViewController;
//    
//    if([segue.identifier isEqualToString:@"NeuroIndexToNeuroHomeSegue"])
//    {
//        destViewController.infoPassingTest = 1;
//    }
//    else if([segue.identifier isEqualToString:@""]){
//        
//    }
//    
//}

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
