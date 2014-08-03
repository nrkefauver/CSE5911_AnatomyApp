//
//  NeuroTractsViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 7/21/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "NeuroTractsViewController.h"

@interface NeuroTractsViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation NeuroTractsViewController
@synthesize efferentTableView, afferentTableView;
NSArray *aTracts, *eTracts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Contents
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    efferentTableView.delegate = self;
    efferentTableView.dataSource = self;
    afferentTableView.delegate = self;
    afferentTableView.dataSource = self;
    
    efferentTableView.backgroundColor = [UIColor blackColor];
    afferentTableView.backgroundColor = [UIColor blackColor];
   
    //This declares the path to the AfferentTracts.plist where all the afferent tracts are found
    NSString *aPath = [[NSBundle mainBundle] pathForResource:@"AfferentTracts" ofType:@"plist"];
    
    //Iterates through entire list and creates array containing all the Afferent tracts
    aTracts = [[NSArray alloc] initWithContentsOfFile:aPath];
    
    //This declares the path to the AfferentTracts.plist where all the afferent tracts are found
    NSString *ePath = [[NSBundle mainBundle] pathForResource:@"EfferentTracts" ofType:@"plist"];
    
    //Iterates through entire list and creates array containing all the Afferent tracts
    eTracts = [[NSArray alloc] initWithContentsOfFile:ePath];

    // If triggered by a media button, play video
    if (_startUpVideoName != nil)
    {
        // Run in the background while the page finishes loading
        [self performSelectorInBackground:@selector(startWithMovie) withObject:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == efferentTableView) {
        return eTracts.count;
    } else {
        return aTracts.count;
    }
}

// Create cell contents
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"tractsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == efferentTableView) {
    cell.textLabel.text = [eTracts objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [aTracts objectAtIndex:indexPath.row];

    }
    cell.backgroundColor= [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:14.0];
    cell.textLabel.layer.borderWidth = 1.0f;
    cell.textLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    //cell.textLabel.layer.cornerRadius = 8.0f;
    return cell;
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
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter N"],
                        [UIImage imageNamed:@"home"],
                        ];
    NSArray *labels = @[@"Tracts",
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
    
    //Tracts clicked
    if (index == 0) {
        // Do nothing
    }
    //Index clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"NeuroTractsToNeuroIndexSegue" sender:self];
    }
    //Neuro Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"NeuroTractsToNeuroHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"NeuroTactsToHomeSegue" sender:self];
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
