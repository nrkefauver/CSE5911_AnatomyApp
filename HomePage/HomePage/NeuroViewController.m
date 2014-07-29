//
//  NeuroViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "NeuroViewController.h"
#import "PopoverTableViewController.h"

@interface NeuroViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

// Popover
- (IBAction)showPopover:(UIButton *)sender;
@property (nonatomic,strong) UIPopoverController *popOver;

@end

@implementation NeuroViewController

@synthesize infoPassingTest;
@synthesize imageView = nImageView;

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
    
    //Loads main image to Neuro main screen
    UIImage* image = [UIImage imageNamed:@"CervicalBlack"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
    
    if (infoPassingTest == 1)
    {
        self.title = @"One";
    }
    
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.clipsToBounds = YES;
    self.imageView.image = image;
    
    
    [self.scrollView setMaximumZoomScale:7.0];
    [self.scrollView setClipsToBounds:YES];
    [self.scrollView delegate];}

//Used for tabbed images
- (void)viewDidUnload
{
    self.imageView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Switches images based on tab clicked on Neuro main page
- (IBAction)contentModeChanged:(UISegmentedControl *)segmentedControl
{
    switch(segmentedControl.selectedSegmentIndex)
    {
        case 0:
            self.imageView.image = [UIImage imageNamed:@"CervicalBlack"];
            break;
        case 1:
            self.imageView.image = [UIImage imageNamed:@"ThoracicBlack"];
            break;
        case 2:
            self.imageView.image = [UIImage imageNamed:@"LumbarBlack"];
            break;
        case 3:
            self.imageView.image = [UIImage imageNamed:@"SacralBlack"];
            break;
    }
}

#pragma mark - Sidebar
// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"videos"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter N"],
                        [UIImage imageNamed:@"home"],
                        ];
    NSArray *labels = @[@"Tracts",
                        @"Index",
                        @"Neuro",
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
    
    //Animations clicked
    if (index == 0) {
        [self performSegueWithIdentifier:@"NeuroHomeToNeuroTractsSegue" sender:self];
    }
    //Index clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"NeuroHomeToNeuroIndex" sender:self];
    }
    //Neuro Home clicked
    else if (index == 2) {
        // Do nothing
    }
    //Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"NeuroToHomeSegue" sender:self];
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

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

// Show popover menu when user clicks "Fasciculus Cuneatus"
- (IBAction)onFasciculusCuneatus:(id)sender
{
    // TODO: Change image to colored
    
    
    // Set index for term 10: Fasciculus Cuneatus
    int index = 17;
    [self showPopoverLeft:(id)sender index:(int)index];
}

// Create Popover menu LEFT button
- (void)showPopoverLeft:(UIButton *)sender index:(int)termIndex
{
    PopoverTableViewController *PopoverView =[[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil ];
    [PopoverView setIndex:(int)termIndex];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

// Create Popover menu RIGHT button
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
