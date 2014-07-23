//
//  GrossViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "GrossViewController.h"
#import "PopoverTableViewController.h"

@interface GrossViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

// Popover
- (IBAction)showPopover:(UIButton *)sender;
@property (nonatomic,strong) UIPopoverController *popOver;

@end

@implementation GrossViewController;

@synthesize LabeledImage;
@synthesize annotations;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;
@synthesize button7;
@synthesize button8;
@synthesize button9;



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
    // Do any additional setup after loading the view.    
    // Load labeled image to home
    UIImage *labeledImage = [UIImage imageNamed:@"Gross_labeled.jpg"];
    [super viewDidLoad];
    [LabeledImage setImage:labeledImage];
    
    // If gross home has been passed a term to popup, show popup window
    if (self.initialPopupName != nil)
    {
        // Run in the background while the page finishes loading
        [self performSelectorInBackground:@selector(showInitialPopup) withObject:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    self.LabeledImage = nil;
    [super viewDidUnload];
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
        [self performSegueWithIdentifier:@"GrossHomeToGrossVideosSegue" sender:self];
    }
    //3D Models clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"GrossHomeToGross3DModelSegue" sender:self];
    }
    //Index clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"GrossHomeToGrossIndex" sender:self];
    }
    //Gross Home clicked
    else if (index == 3) {
        // Do nothing
    }
    //Home clicked
    else if (index == 4) {
        [self performSegueWithIdentifier:@"GrossToHomeSegue" sender:self];
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

#pragma mark - Popover
// Wait in the background then
- (void) showInitialPopup
{
    // Wait to finish transition
    sleep(0.75);
    
    // In the main thread, show popup window
    [self performSelectorOnMainThread:@selector(initialPopup) withObject:nil waitUntilDone:NO];
}

// Show popup window upon page loading
- (void) initialPopup
{
    UIButton *dorsalRoots = (UIButton*)[self.view viewWithTag:10];

    [dorsalRoots sendActionsForControlEvents: UIControlEventTouchUpInside];
}

// Show popover menu when user clicks "Dorsal Roots"
- (IBAction)onDorsalRoots:(id)sender
{
    // Set index for term 15: DorsalRoots
    int index = 15;
    [self showPopoverBelow:(id)sender index:(int)index];
    
}

// Show popover menu when user clicks "Dorsal Horn of Gray Matter"
- (IBAction)onDorsalHornOfGrayMatter:(id)sender
{
    // Set index for term 10: DoralHornOfGrayMatter
    int index = 10;
    [self showPopoverRight:(id)sender index:(int)index];
}

// Show popover menu when user clicks "Dorsal Root Ganglion"
- (IBAction)onDorsalRootGanglion:(id)sender
{
    // Set index for term 14: DorsalRootGanglion
    int index = 14;
    [self showPopoverAbove:(id)sender index:(int)index];
}

// Show popover menu when user clicks "Spinal Nerve"
- (IBAction)onSpinalNerve:(id)sender
{
    // Set index for term 40: SpinalNerve
    //int index = 40;
    //[self showPopoverRight:(id)sender index:(int)index];
    [self showInitialPopup];
}

// Show popover menu when user clicks "Ventral Median Fissure"
- (IBAction)onVentralMedianFissure:(id)sender
{
    // Set index for term 44: VentralMedianFissure
    int index = 44;
    [self showPopoverLeft:(id)sender index:(int)index];
}

// Show popover menu when user clicks "Ventral Roots"
- (IBAction)onVentralRoots:(id)sender
{
    // Set index for term 45: VentralRoots
    int index = 45;
    [self showPopoverRight:(id)sender index:(int)index];
}

// Show popover menu when user clicks "Ventral Horn of Gray Matter"
- (IBAction)onVentralHornOfGrayMatter:(id)sender
{
    // Set index for term 43: VentralHornOfGrayMatter
    int index = 43;
    [self showPopoverLeft:(id)sender index:(int)index];
}

// Show popover menu when user clicks "Dorsal Primary Ramus"
- (IBAction)onDorsalPrimaryRamus:(id)sender
{
    // Set index for term 124: DorsalPrimaryRamus
    int index = 123;
    [self showPopoverAbove:(id)sender index:(int)index];
}

// Show popover menu when user clicks "Ventral Primary Ramus"
- (IBAction)onVentralPrimaryRamus:(id)sender
{
    // Set index for term 140: VentralPrimaryRamus
    int index = 139;
    [self showPopoverBelow:(id)sender index:(int)index];
}

// Create Popover menu BELOW button
- (void)showPopoverLeft:(UIButton *)sender index:(int)termIndex
{
    PopoverTableViewController *PopoverView =[[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil ];
    [PopoverView setIndex:(int)termIndex];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

// Create Popover menu BELOW button
- (void)showPopoverRight:(UIButton *)sender index:(int)termIndex
{
    PopoverTableViewController *PopoverView =[[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil ];
    [PopoverView setIndex:(int)termIndex];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

// Create Popover menu BELOW button
- (void)showPopoverBelow:(UIButton *)sender index:(int)termIndex
{
    PopoverTableViewController *PopoverView =[[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil ];
    [PopoverView setIndex:(int)termIndex];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

// Create Popover menu ABOVE button
- (void)showPopoverAbove:(UIButton *)sender index:(int)termIndex
{
    PopoverTableViewController *PopoverView =[[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil ];
    [PopoverView setIndex:(int)termIndex];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction) toggleAnnotationsSwitch: (id) sender {
    // If the annotations button is on, draw the labeled image
    if (annotations.on) {
        UIImage *labeledImage = [UIImage imageNamed:@"Gross_labeled.jpg"];
        [super viewDidLoad];
        [LabeledImage setImage:labeledImage];
        button1.enabled = YES;
        button2.enabled = YES;
        button3.enabled = YES;
        button4.enabled = YES;
        button5.enabled = YES;
        button6.enabled = YES;
        button7.enabled = YES;
        button8.enabled = YES;
        button9.enabled = YES;
    }
    else {  // If annotations switch is off, draw unlabeled image
        UIImage *labeledImage = [UIImage imageNamed:@"Gross_unlabeled.jpg"];
        [super viewDidLoad];
        [LabeledImage setImage:labeledImage];
        button1.enabled = NO;
        button2.enabled = NO;
        button3.enabled = NO;
        button4.enabled = NO;
        button5.enabled = NO;
        button6.enabled = NO;
        button7.enabled = NO;
        button8.enabled = NO;
        button9.enabled = NO;
    }
}

@end
