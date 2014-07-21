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
    
    if (self.initialPopupName != nil)
    {
        [self showInitialPopup];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set navigation bar color
    return YES;
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
// Popover menu upon loading view controller
- (void) showInitialPopup
{
    // Set index for term 15: DoralRoots
    int index = 15;
    [self showPopoverBelow:nil index:(int)index];
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
    int index = 40;
    [self showPopoverRight:(id)sender index:(int)index];
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

@end
