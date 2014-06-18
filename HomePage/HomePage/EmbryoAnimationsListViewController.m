//
//  EmbryoAnimationsListViewController.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/9/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "EmbryoAnimationsListViewController.h"

@interface EmbryoAnimationsListViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation EmbryoAnimationsListViewController

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

- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Animations"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter E"],
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
    
    //Animations clicked
    if (index == 0) {
        //Do nothing
    }
    
    //Index clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"EmbryoAnimationsListToIndexSegue" sender:self];
    }
    
    //Embryo Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"EmbryoAnimationsListToEmbryoHomeSegue" sender:self];
    }
    
    //Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"EmbryoAnimationsListToHomeSegue" sender:self];
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

-(IBAction)onVideoPlay:(id)sender {
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Neuraltube_001" ofType:@"mp4"];
    NSURL *streamURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerController *moviplayer =[[MPMoviePlayerController alloc] initWithContentURL:     streamURL];
    
    [moviplayer prepareToPlay];
    [moviplayer.view setFrame: self.view.bounds];
    [self.view addSubview: moviplayer.view];
    
    moviplayer.fullscreen = NO;
    moviplayer.shouldAutoplay = YES;
    moviplayer.repeatMode = MPMovieRepeatModeOne;
    moviplayer.movieSourceType = MPMovieSourceTypeFile;
    [moviplayer play];
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
