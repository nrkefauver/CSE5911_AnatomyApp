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
    
    
    titleArray = [[NSMutableArray alloc] init];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Neuroterms" ofType:@"plist"];
    
    //Creates dictionary of Neuroanatomy terms
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //Create alphabetical list of definition names
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedValues = [dict objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    titleArray = sortedKeys;
    
    //Creates an array of definition names
    subtitleArray = sortedKeys;
    
    //Creates array of definitions
    textArray = sortedValues;
    
    // Setup some test data
    dataSection01 = [[NSMutableArray alloc] initWithObjects:titleArray, nil];
//    dataSection02 = [[NSMutableArray alloc] initWithObjects:@"Federer", @"Nadal", nil];
//    dataSection03 = [[NSMutableArray alloc] initWithObjects:@"Naples", @"Genoa", @"New York", nil];
//    dataSection04 = [[NSMutableArray alloc] initWithObjects:@"Adele", @"Arisa", @"Clementino", nil];
//    dataSection05 = [[NSMutableArray alloc] initWithObjects:@"Red", @"Orange", @"Blue", @"Yello", @"Black", nil];
//    dataSection06 = [[NSMutableArray alloc] initWithObjects:@"Italy", @"Spain", @"Ireland", @"Scotland", @"Poland", nil];
    //
    
    // Section graphics
    UIColor *sectionsColor = [UIColor colorWithRed:62.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
    UIColor *sectionTitleColor = [UIColor whiteColor];
    UIFont *sectionTitleFont = [UIFont fontWithName:@"Futura" size:24.0f];
    
    // Add the sections to the controller
    EMAccordionSection *section01 = [[EMAccordionSection alloc] init];
    [section01 setBackgroundColor:sectionsColor];
    [section01 setItems:dataSection01];
    [section01 setTitle:@"Neuroanatomy"];
    [section01 setTitleFont:sectionTitleFont];
    [section01 setTitleColor:sectionTitleColor];
    [emTV addAccordionSection:section01];
    
//    EMAccordionSection *section02 = [[EMAccordionSection alloc] init];
//    [section02 setBackgroundColor:sectionsColor];
//    [section02 setItems:dataSection02];
//    [section02 setTitle:@"NeuroAnatomy"];
//    [section02 setTitleColor:sectionTitleColor];
//    [section02 setTitleFont:sectionTitleFont];
//    [emTV addAccordionSection:section02];
//    
//    EMAccordionSection *section03 = [[EMAccordionSection alloc] init];
//    [section03 setBackgroundColor:sectionsColor];
//    [section03 setItems:dataSection03];
//    [section03 setTitle:@"Gross Anatomy"];
//    [section03 setTitleColor:sectionTitleColor];
//    [section03 setTitleFont:sectionTitleFont];
//    [emTV addAccordionSection:section03];
//    
//    EMAccordionSection *section04 = [[EMAccordionSection alloc] init];
//    [section04 setBackgroundColor:sectionsColor];
//    [section04 setItems:dataSection04];
//    [section04 setTitle:@"Embryology"];
//    [section04 setTitleColor:sectionTitleColor];
//    [section04 setTitleFont:sectionTitleFont];
//    [emTV addAccordionSection:section04];

    sections = [[NSArray alloc] initWithObjects:section01, nil];
    
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
    
//    titleArray = [[NSMutableArray alloc] init];
//   
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Neuroterms" ofType:@"plist"];
//    
//    //Creates dictionary of Neuroanatomy terms
//   NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
//    
//    //Create alphabetical list of definition names
//    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
//    
//    //Create alphabetical list of definitions
//    NSArray * sortedValues = [dict objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
//    
//    //Creates an array of all the definition names to be searched through
//    titleArray = sortedKeys;
//    
//    //Creates an array of definition names
//    subtitleArray = sortedKeys;
//    
//    //Creates array of definitions
//    textArray = sortedValues;
    

  
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
        return titleArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"expandingCell";
    
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    //Later
    if (selectedIndex == indexPath.row) {
        //Do expanded cell stuff
    }
    else {
        //Do closed cell stuff
    }
    
    //COLLAPSIBLE CODE
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, self.view.bounds.size.width - origin*2 - 10.0f, kTableRowHeight)];
//    [titleLbl setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:12.0f]];
//    [titleLbl setText:[items objectAtIndex:indexPath.row]];
//    [titleLbl setBackgroundColor:[UIColor clearColor]];
//    
//    [[cell contentView] addSubview:titleLbl];

    
    NSString *term;
    if (indexPath.row <= titleArray.count) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            term =[searchResults objectAtIndex:indexPath.row];
            cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
            cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
            int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
            cell.textLabel.text = [textArray objectAtIndex:pos];
        } else {
            cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [textArray objectAtIndex:indexPath.row];
        }
        
    }
    
    cell.clipsToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedIndex == indexPath.row) {
        return 200;
    } else {
        return 38;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //User taps expanded row
    if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //User taps different row
    
    if (selectedIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow: selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //User taps new row with none expanded
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith [c] %@", searchText];
    searchResults = [titleArray filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [controller.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                                        selectedScopeButtonIndex]]];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
