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
@synthesize HistoWeb;
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
    
    NSLog(@"%d",self.histoSlideNumber);
    
    //1
    NSString *urlString=@"https://a.tiles.mapbox.com/v4/nrkefauver.j1n13p1d/page.html?access_token=pk.eyJ1IjoibnJrZWZhdXZlciIsImEiOiJycUY1bngwIn0.oDZn8xaNJXUNGXCaRgC1wg#3/15.03/14.68";
    if(self.histoSlideNumber==1){
        urlString=@"https://a.tiles.mapbox.com/v4/nrkefauver.j1n13p1d/page.html?access_token=pk.eyJ1IjoibnJrZWZhdXZlciIsImEiOiJycUY1bngwIn0.oDZn8xaNJXUNGXCaRgC1wg#3/15.03/14.68";
    }else if(self.histoSlideNumber==2){
        urlString = @"https://a.tiles.mapbox.com/v4/nrkefauver.j4n9ndfh/page.html?access_token=pk.eyJ1IjoibnJrZWZhdXZlciIsImEiOiJycUY1bngwIn0.oDZn8xaNJXUNGXCaRgC1wg#3/0.00/0.00";
    }
    
    //2
    NSURL *url = [NSURL URLWithString:urlString];
    
    //3
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //4
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //5
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [HistoWeb loadRequest:request];
         else if (error != nil) NSLog(@"Error: %@", error);
     }];
    
   
    
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
        [self performSegueWithIdentifier:@"HistoBlueSlideToHistoIndexSegue" sender:self];
    }
    //Histo Home clicked
    else if (index == 1) {
        [self performSegueWithIdentifier:@"HistoBlueSlideToHistoHomeSegue" sender:self];
    }
    //Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"HistoBlueSlideToHomeSegue" sender:self];
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
