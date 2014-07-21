//
//  NeuroTractsViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 7/21/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "NeuroTractsViewController.h"

@interface NeuroTractsViewController ()

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == efferentTableView) {
        return eTracts.count;
    } else {
        return aTracts.count;
    }
}

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
