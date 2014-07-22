//
//  HistoIndexViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 6/10/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "HistoIndexViewController.h"
#import "ExpandingCell.h"
#import "Term.h"

@interface HistoIndexViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation HistoIndexViewController
NSArray *searchResults;
static NSIndexPath *globalIndexPath;
static UITableView *globalTableView;
static bool tableViewIsCreated = false;
static enum selectedDisciplineEnum selectedDiscipline = histo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Contents
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Testing expandable cells code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
    
    titleArray = [[NSMutableArray alloc] init];
    subtitleArray = [[NSMutableArray alloc] init];
    textArray = [[NSMutableArray alloc] init];
    masterDictionary = [[NSMutableDictionary alloc] init];
    
    //This declares the path to the Terms.plist where all the terms for the entire project are found
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"plist"];
    
    //Iterates through entire terms list and creates array containing all the Neuroanatomy (array) terms
    NSArray *terms = [[NSArray alloc] initWithContentsOfFile:path];
    
    //Create temp array for keys
    NSMutableArray *tempNames = [[NSMutableArray alloc] init];
    NSMutableArray *tempDefs = [[NSMutableArray alloc] init];
    NSMutableArray *defOptions = [[NSMutableArray alloc] init];

    for (int i=0; i< 140; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:2] isEqualToString:@""]) {
                [titleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
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
    //Adds all Histo terms and their designated definitions to the overall dictionary
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];
    
    //Create Dictionary for terms and their definitions
    NSDictionary *nTerms = [[NSDictionary alloc] initWithObjects:tempDefs forKeys:tempNames];
    
    //Create alphabetical list of definition names
    NSArray * sortedKeys = [[nTerms allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedValues = [nTerms objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    titleArray = sortedKeys;
    
    //Creates an array of definition names
    subtitleArray = sortedKeys;
    
    //Creates array of definitions
    textArray = sortedValues;
    
    
    
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
    // Access expanding cell
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    NSString *term;
    if (selectedDiscipline == neuro)
    {
        if (indexPath.row <= titleArray.count) {
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                term =[searchResults objectAtIndex:indexPath.row];
                cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
                cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
                cell.textLabel.text = [[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:0];
            } else {
                cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
                cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
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
            cell.titleLabel.text = @"hist";
            cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
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
            cell.titleLabel.text = @"emb";
            cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
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
            cell.titleLabel.text = @"gro";
            cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
            cell.textLabel.text =[[masterDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:3];
        }
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
    
    // Set media buttons based on the selected discipline
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
        return 38;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Access expandingCell's segmented controller
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
    cell = [nib objectAtIndex:0];
    // Set preselected term in the segmented control (tag 1000):
    UIView *nibView = [nib objectAtIndex:0];
    UISegmentedControl *segmentedControl = (UISegmentedControl*)[nibView viewWithTag:1000];
    // Set segController to Histo
    selectedDiscipline = histo;
    
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
//    //NeuroViewController* destViewController = segue.destinationViewController;
//
//    if([segue.identifier isEqualToString:@""])
//    {
//        //destViewController.infoPassingTest = 1;
//    }
//    else if([segue.identifier isEqualToString:@""]){
//
//    }
//
//}

#pragma mark - Search Bar
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
    // close any open cells
    selectedIndex = -1;
    selectedDiscipline = histo;
    
    return YES;
}

// If cells have been opened, close them when starting search
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if (tableViewIsCreated)
    {
        selectedIndex = -1;
        [globalTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:globalIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// Don't let searchDisplayControllerWillBeginSearch reload globalTableView if it hasn't been established
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    tableViewIsCreated = false;
}

// Prevent other indices from crashing if "cancel" was hit while results were being displayed
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)@""];
}

#pragma mark - Sidebar
// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter H"],
                        [UIImage imageNamed:@"home"],
                        ];
    NSArray *labels = @[@"Index",
                        @"Histo",
                        @"Home",];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:nil labelStrings:labels];
    callout.delegate = self;
    callout.showFromRight = YES;
    [callout showInViewController:self animated:YES];
}
- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

// Set sidebar navigation
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    //Index clicked
    if (index == 0) {
        //Do nothing
    }
    //Histo Home clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"HistoIndexToHistoHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"HistoIndexToHomeSegue" sender:self];
    }
    
    [sidebar dismissAnimated:YES];
}

// Hide navigation bar when sidebar is open
- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:NO animated:animatedYesOrNo];
}
- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:YES animated:animatedYesOrNo];
}

@end

