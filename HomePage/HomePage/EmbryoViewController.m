//
//  EmbryoViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "EmbryoViewController.h"

@interface EmbryoViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation EmbryoViewController
@synthesize imageView = eImageView;
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
    UIImage* image = [UIImage imageNamed:@"E0"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.clipsToBounds = YES;
    self.imageView.image = image;
    
    [self.scrollView setMaximumZoomScale:7.0];
    [self.scrollView setClipsToBounds:NO];
}

- (IBAction)contentModeChanged:(UISegmentedControl *)segmentedControl
{
    //Switches images based on tab clicked on Neuro main page
    switch(segmentedControl.selectedSegmentIndex)
    {
        case 0:
            self.imageView.image = [UIImage imageNamed:@"E0"];
            break;
        case 1:
            self.imageView.image = [UIImage imageNamed:@"E1"];
            break;
        case 2:
            self.imageView.image = [UIImage imageNamed:@"E2"];
            break;
        case 3:
            self.imageView.image = [UIImage imageNamed:@"E3"];
            break;
        case 4:
            self.imageView.image = [UIImage imageNamed:@"E4"];
            break;
        case 5:
            self.imageView.image = [UIImage imageNamed:@"E5"];
            break;
        case 6:
            self.imageView.image = [UIImage imageNamed:@"E6"];
            break;
        case 7:
            self.imageView.image = [UIImage imageNamed:@"E7"];
            break;
    }
}

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

#pragma mark - Sidebar
// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"videos"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter E"],
                        [UIImage imageNamed:@"home"],
                        ];
    NSArray *labels = @[@"Animations",
                        @"Index",
                        @"Embryo",
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
        [self performSegueWithIdentifier:@"EmbryoHomeToAnimationsListSegue" sender:self];
    }
    //Index clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"EmbryoHomeToEmbryoIndex" sender:self];
    }
    //Embryo Home clicked
    else if (index == 2) {
        // Do nothing
    }
    //Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"EmbryoToHomeSegue" sender:self];
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

@end
