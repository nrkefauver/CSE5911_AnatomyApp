//
//  GrossIndexViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 6/10/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "GrossIndexViewController.h"
#import "NeuroViewController.h"
#import "NeuroTractsViewController.h"
#import "HistoSlide1ViewController.h"
#import "EmbryoViewController.h"
#import "EmbryoAnimationsListViewController.h"
#import "Gross3DModelViewController.h"
#import "GrossViewController.h"
#import "GrossVideoListViewController.h"
#import "ExpandingCell.h"

@interface GrossIndexViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation GrossIndexViewController
NSArray *searchResults;
static NSIndexPath *globalIndexPath;
static UITableView *globalTableView;
static bool tableViewIsCreated = false;
static enum selectedDisciplineEnum selectedDiscipline = gross;
static int NeuroMedia = 5; //Position in property list for all Neuro Media options
static int HistoMedia = 6; //Position in property list for all Histo Media options
static int EmbryoMedia = 7; //Position in property list for all Embryo Media options
static int GrossMedia = 8; //Position in property list for all Gross Media options
static NSString *partName; //Name of term to display with Popover window in Gross Home
static NSString *videoName; //Name of video to play in Embryo Animations List or Gross Video List
static bool mediaButtonSegue = false; //Tracks if a segue is triggered by a media button or not


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
    
    //Initialize all necessary arrays
    titleArray = [[NSMutableArray alloc] init];
    subtitleArray = [[NSMutableArray alloc] init];
    textArray = [[NSMutableArray alloc] init];
    masterDictionary = [[NSMutableDictionary alloc] init];
    mediaDictionary = [[NSMutableDictionary alloc] init];

    
    //This declares the path to the Terms.plist where all the terms for the entire project are found
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"plist"];
    
    //Iterates through entire terms list and creates array containing all the Gross (array) terms
    NSArray *terms = [[NSArray alloc] initWithContentsOfFile:path];
    
    //Create temp array for keys
    NSMutableArray *tempNames = [[NSMutableArray alloc] init];
    NSMutableArray *tempDefs = [[NSMutableArray alloc] init];
    NSMutableArray *defOptions = [[NSMutableArray alloc] init];
    NSMutableArray *mediaOptions = [[NSMutableArray alloc] init];
    for (int i=0; i< terms.count; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            //The Gross definition field of each term is checked, and if it is not empty, then the term
            //is added to the list of Gross terms
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:4] isEqualToString:@""]) {
                [titleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:4] ];
                
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
    
    //Adds all Gross terms and their designated definitions to the overall dictionary
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjects:defOptions forKeys:tempNames];
    [masterDictionary addEntriesFromDictionary:tempDict];
    
    //Adds all Gross terms and their designated media to the media dictionary
    NSDictionary *mediaDict = [[NSDictionary alloc] initWithObjects:mediaOptions forKeys:tempNames];
    [mediaDictionary addEntriesFromDictionary:mediaDict];
    
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
    
    mediaButtonSegue = false;
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

// Create cell contents
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Access expanding cell
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    // Populate cells with terms and definitions
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
                UIImage* button1Image = [UIImage imageNamed:@"2DImageMediaButton"];
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
                    UIImage* button2Image = [UIImage imageNamed:@"AnimationMediaButton"];
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
                    UIImage* button1Image = [UIImage imageNamed:@"AnimationMediaButton"];
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
                UIImage* button1Image = [UIImage imageNamed:@"2DImageMediaButton"];
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
            break;
        }
            
        {case 2: //Embryo
            // Set the segmented control to Embryo
            [segmentedControl setSelectedSegmentIndex:2];
            
            // Used for setting the media buttons from left to right
            bool button1IsTaken = false;
            
            // Set button for 2D Image if applicable
            NSLog(@"_%@_",[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2]objectAtIndex:1]);
            if (![[[[mediaDictionary objectForKey:cell.subtitleLabel.text] objectAtIndex:2]objectAtIndex:1]isEqualToString:@""])
            {
                // Set videos
                UIImage* button1Image = [UIImage imageNamed:@"2DImageMediaButton"];
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
                    UIImage* button2Image = [UIImage imageNamed:@"AnimationMediaButton"];
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
                    UIImage* button1Image = [UIImage imageNamed:@"AnimationMediaButton"];
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
                UIImage* button1Image = [UIImage imageNamed:@"3DModelMediaButton"];
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
                    UIImage* button2Image = [UIImage imageNamed:@"2DImageMediaButton"];
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
                    UIImage* button1Image = [UIImage imageNamed:@"2DImageMediaButton"];
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
                    UIImage* button3Image = [UIImage imageNamed:@"VideoMediaButton"];
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
                    UIImage* button2Image = [UIImage imageNamed:@"VideoMediaButton"];
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
                    UIImage* button1Image = [UIImage imageNamed:@"VideoMediaButton"];
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
    // Set segController to Gross
    selectedDiscipline = gross;
    
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

//Switches definitions and media based on selected subdiscipline
- (IBAction)switchSelectedDiscipline:(UISegmentedControl *)segmentedControl
{
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
    [self performSegueWithIdentifier:@"GrossIndexToNeuroHomeSegue" sender:self];
}

- (void) neuroAnimationButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToNeuroTractsSegue" sender:self];
}

- (void) histo2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToHistoSlideSegue" sender:self];
}

- (void) embryoAnimationButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToEmbryoAnimationsListSegue" sender:self];
}

- (void) embryo2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToEmbryoHomeSegue" sender:self];
}

- (void) gross3DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToGross3DModelSegue" sender:self];
}

- (void) gross2DButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToGrossHomeSegue" sender:self];
}

- (void) grossVideoButtonPressed
{
    mediaButtonSegue = true;
    [self performSegueWithIdentifier:@"GrossIndexToGrossVideosSegue" sender:self];
}

// If segue is triggered by a media button, pass information
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
        //if([segue.identifier isEqualToString:@"GrossIndexToNeuroHomeSegue"])
        //{
        //    neuroHomeVC = segue.destinationViewController;
              //Set passed info
        
              //When this code is written, change the following "if" to an "else if"
        //}
        // Neuro Animation
        if([segue.identifier isEqualToString:@"GrossIndexToNeuroTractsSegue"])
        {
            neuroTractsVC = segue.destinationViewController;
            neuroTractsVC.startUpVideoName = videoName;
        }
        // Histo 2D
        //else if([segue.identifier isEqualToString:@""])
        //{
        //    histoSlideVC = segue.destinationViewController;
              //Set passed info
        //}
        // Embryo 2D
        //else if([segue.identifier isEqualToString:@""])
        //{
        //    embryoHomeVC = segue.destinationViewController;
              //Set passed info
        //}
        // Embryo Animation
        else if([segue.identifier isEqualToString:@"GrossIndexToEmbryoAnimationsListSegue"])
        {
            embryoAnimationVC = segue.destinationViewController;
            embryoAnimationVC.startUpVideoName = videoName;
        }
        // Gross 2D
        if([segue.identifier isEqualToString:@"GrossIndexToGrossHomeSegue"])
        {
            grossHomeVC = segue.destinationViewController;
            grossHomeVC.initialPopupName = partName;
        }
        // Gross 3D
        //else if([segue.identifier isEqualToString:@"GrossIndexToGross3DModelSegue"])
        //{
        //    gross3DVC = segue.destinationViewController;
              //Set passed info
        //}
        // Gross Video
        else if([segue.identifier isEqualToString:@"GrossIndexToGrossVideosSegue"])
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
    searchResults = [titleArray filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [controller.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                                        selectedScopeButtonIndex]]];
    // close any open cells
    selectedIndex = -1;
    selectedDiscipline = gross;
    
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
                        [UIImage imageNamed:@"videos"],
                        [UIImage imageNamed:@"3D Models"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter G"],
                        [UIImage imageNamed:@"home"],
                        ];
    NSArray *labels = @[@"Videos",
                        @"3D Model",
                        @"Index",
                        @"Gross",
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
    
    //Videos clicked
    if (index == 0) {
        [self performSegueWithIdentifier:@"GrossIndexToGrossVideosSegue" sender:self];
    }
    //3D Models clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"GrossIndexToGross3DModelSegue" sender:self];
    }
    //Index clicked
    else if (index == 2) {
        //Do nothing
    }
    //Gross Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"GrossIndexToGrossHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 4) {
        [self performSegueWithIdentifier:@"GrossIndexToHomeSegue" sender:self];
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

