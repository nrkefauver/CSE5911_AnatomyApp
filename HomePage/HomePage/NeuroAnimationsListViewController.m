//
//  NeuroAnimationsListViewController.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/9/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "NeuroAnimationsListViewController.h"

@interface NeuroAnimationsListViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation NeuroAnimationsListViewController

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
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter N"],
                        [UIImage imageNamed:@"home"],
                        ];
    NSArray *labels = @[@"Animations",
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
        //Do nothing
    }
    //Index clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"NeuroAnimationsListToNeuroIndexSegue" sender:self];
    }
    //Neuro Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"NeuroAnimationsListToNeuroHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"NeuroAnimationsListToHomeSegue" sender:self];
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

// Example Animation button pressed
- (IBAction)onNeuralTube001:(id)sender
{
    [self playMovie:(id)sender movieName:(NSString*)@"Neuraltube_001" fileType:(NSString*)@"mp4"];
}

// Play video
-(void)playMovie:(id)sender movieName:(NSString*)moviePath fileType:(NSString*)fileType
{
    NSString*path=[[NSBundle mainBundle] pathForResource:moviePath ofType:fileType];
    NSURL*url=[NSURL fileURLWithPath:path];
    
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
    
}

// End video
- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
}


@end
