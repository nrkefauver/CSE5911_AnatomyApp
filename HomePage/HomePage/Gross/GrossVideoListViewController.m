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
    
    // If triggered by a media button, play video
    if (_startUpVideoName != nil)
    {
        // Run in the background while the page finishes loading
        [self performSelectorInBackground:@selector(startWithMovie) withObject:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Videos
// If sent movie information, autoplay video
- (void) startWithMovie
{
    // Wait for page to finish animation
    sleep(0.5);
    
    // In the main thread, show popup window
    [self performSelectorOnMainThread:@selector(playStartupMovie) withObject:nil waitUntilDone:NO];
}

// Show movie upon startup
- (void) playStartupMovie
{
    // TODO - change hardcoded values
    [self playMovie:self movieName:(NSString*)@"Neuraltube_001" fileType:(NSString*)@"mp4"];
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
