//
//  HistoSlide2ViewController.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/17/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "HistoSlide2ViewController.h"

@interface HistoSlide2ViewController ()

@end

@implementation HistoSlide2ViewController

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
    UIImage *RSpinal = [UIImage imageNamed:@"1.jpg"];
    [super viewDidLoad];
    
    [imageView setImage:RSpinal];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
