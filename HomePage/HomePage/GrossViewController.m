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

@implementation GrossViewController
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
    //Loads main image to Gross main screen
    UIImage* image = [UIImage imageNamed:@"Gross"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.clipsToBounds = YES;
    self.imageView.image = image;
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
    self.imageView = nil;
    [super viewDidUnload];
}

// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"videos"],
                        [UIImage imageNamed:@"3D Models"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter G"],
                        [UIImage imageNamed:@"home"],
                        ];

    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices];
    callout.delegate = self;
    callout.showFromRight = YES;
    [callout showInViewController:self animated:YES];
}

// Set sidebar navigation
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    [sidebar dismissAnimated:YES completion:nil];
    
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
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

// Hide navigation bar when sidebar is open
- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:NO animated:animatedYesOrNo];
}
- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:YES animated:animatedYesOrNo];
}

// Popover
- (IBAction)showPopover:(UIButton *)sender
{
    PopoverTableViewController *PopoverView =[[PopoverTableViewController alloc] initWithNibName:@"PopoverTableViewController" bundle:nil];
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:PopoverView];
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

@end
