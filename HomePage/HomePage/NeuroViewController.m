//
//  NeuroViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "NeuroViewController.h"

@interface NeuroViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
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
    UIImage* image = [UIImage imageNamed:@"Cervical"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
    
    if (infoPassingTest == 1)
    {
        self.title = @"One";
    }
    
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.clipsToBounds = YES;
    self.imageView.image = image;
}

//Used for tabbed images
- (void)viewDidUnload
{
    self.imageView = nil;
    [super viewDidUnload];
}


- (IBAction)contentModeChanged:(UISegmentedControl *)segmentedControl
{
    //Switches images based on tab clicked on Neuro main page
    switch(segmentedControl.selectedSegmentIndex)
    {
        case 0:
            self.imageView.image = [UIImage imageNamed:@"Cervical"];
            break;
        case 1:
            self.imageView.image = [UIImage imageNamed:@"Thoracic"];
            break;
        case 2:
           self.imageView.image = [UIImage imageNamed:@"Lumbar"];
            break;
        case 3:
            self.imageView.image = [UIImage imageNamed:@"Sacral"];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Tracts"],
                        [UIImage imageNamed:@"Animations"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter N"],
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
    
    //Tracts clicked
    if (index == 0) {
        //TODO
    }
    
    //Animations clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"NeuroHomeToAnimationsListSegue" sender:self];
    }
    
    //Index clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"NeuroHomeToNeuroIndex" sender:self];
    }
    
    //Neuro Home clicked
    else if (index == 3) {
        // Do nothing
    }
    
    //Home clicked
    else if (index == 4) {
        [self performSegueWithIdentifier:@"NeuroToHomeSegue" sender:self];
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

@end
