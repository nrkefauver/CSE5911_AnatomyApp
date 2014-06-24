//
//  HistologyViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "HistologyViewController.h"

#import "HistologyCollectionViewFlowLargeLayout.h"
#import "HistologyCollectionViewFlowSmallLayout.h"
#import "HistologyCollectionViewCell.h"

@interface HistologyViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) HistologyCollectionViewFlowLargeLayout *largeLayout;
@property (nonatomic, strong) HistologyCollectionViewFlowSmallLayout *smallLayout;
@property (nonatomic, strong) NSArray *images;
@end

static NSString *ItemIdentifier = @"ItemIdentifier";

@implementation HistologyViewController
@synthesize imageView = hImageView;

-(void)loadView
{
    // Important to override this when not using a nib. Otherwise, the collection
    // view will be instantiated with a nil layout, crashing the app.
    
    self.smallLayout = [[HistologyCollectionViewFlowSmallLayout alloc] init];
    self.largeLayout = [[HistologyCollectionViewFlowLargeLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.smallLayout];
    [self.collectionView registerClass:[HistologyCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

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
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Small", @"Large"]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    // Do any additional setup after loading the view.
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
-(void)segmentedControlValueDidChange:(id)sender
{
    if (self.collectionView.collectionViewLayout == self.smallLayout)
    {
        [self.largeLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.largeLayout animated:YES];
    }
    else
    {
        [self.smallLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.smallLayout animated:YES];
    }
}

#pragma mark - UICollectionView DataSource & Delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HistologyCollectionViewCell *cell = (HistologyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    [cell setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", indexPath.item % 4]]];
    
    return cell;
}

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

- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:NO animated:animatedYesOrNo];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:YES animated:animatedYesOrNo];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
