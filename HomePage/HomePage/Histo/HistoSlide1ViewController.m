//
//  HistologySlide1ViewController.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/17/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "HistoSlide1ViewController.h"

@interface HistoSlide1ViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation HistoSlide1ViewController

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
    UIImage *BSpinal = [UIImage imageNamed:@"1.jpg"];
    [super viewDidLoad];
    
    [imageView setImage:BSpinal];
    
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
        [self performSegueWithIdentifier:@"HistoSlideToHistoIndexSegue" sender:self];
    }
    //Histo Home clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"HistoSlideToHistoHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"HistoSlideToHomeSegue" sender:self];
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
