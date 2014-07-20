//
//  GrossVideoListViewController.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/9/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "GrossVideoListViewController.h"
@interface GrossVideoListViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation GrossVideoListViewController

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
        //Do nothing
    }
    //3D Models clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"GrossVideosToGross3DSegue" sender:self];
    }
    //Index clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"GrossVideosToIndexSegue" sender:self];
        
    }
    //Gross Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"GrossVideosToGrossHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 4) {
        [self performSegueWithIdentifier:@"GrossVideosToHomeSegue" sender:self];
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
