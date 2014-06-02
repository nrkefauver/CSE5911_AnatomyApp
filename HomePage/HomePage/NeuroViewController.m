//
//  NeuroViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "NeuroViewController.h"

@interface NeuroViewController ()

@end

@implementation NeuroViewController

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
    UIImage* image = [UIImage imageNamed:@"NeuroC"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
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
            self.imageView.image = [UIImage imageNamed:@"NeuroC"];
            break;
        case 1:
            self.imageView.image = [UIImage imageNamed:@"NeuroT"];
            break;
        case 2:
           self.imageView.image = [UIImage imageNamed:@"NeuroL"];
            break;
        case 3:
            self.imageView.image = [UIImage imageNamed:@"NeuroS"];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
