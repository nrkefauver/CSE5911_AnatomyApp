//
//  HomePageViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "HomePageViewController.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addButton];
}

-(void) addButton
{
    // Create a button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(doAThing)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"PROGRAMMATIC ACTION" forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"home.png"];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = CGRectMake(20.0, 70.0, 300.0, 40.0);
    [self.view addSubview:button];
}

- (void) doAThing
{
    [self addButton2];
}

-(void) addButton2
{
    // Create a button
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self
               action:@selector(doAThing2)
     forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"Yo Dawg I heard ya liked buttons" forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"home.png"];
    [button2 setImage:img forState:UIControlStateNormal];
    button2.frame = CGRectMake(20.0, 300.0, 300.0, 40.0);
    [self.view addSubview:button2];
}

- (void) doAThing2
{
    self.title = @"This Works Good";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
