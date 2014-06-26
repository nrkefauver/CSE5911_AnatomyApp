//
//  HistologyViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "HistologyViewController.h"


@interface HistologyViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

static NSString *ItemIdentifier = @"ItemIdentifier";

@implementation HistologyViewController
@synthesize BlueSpinal;
@synthesize RedSpinal;

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
    UIImage *BSpinal = [UIImage imageNamed:@"0.jpg"];
    [super viewDidLoad];
    
    UIImage *RSpinal = [UIImage imageNamed:@"1.jpg"];
    [super viewDidLoad];
 
    [BlueSpinal setImage:BSpinal];
    [RedSpinal setImage:RSpinal];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource & Delegate methods


// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter H"],
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
    
    //Index clicked
    if (index == 0) {
        [self performSegueWithIdentifier:@"HistoHomeToHistoIndex" sender:self];
    }
    
    //Histo Home clicked
    else if (index == 1) {
        // Do nothing
    }
    
    //Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"HistoToHomeSegue" sender:self];
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
