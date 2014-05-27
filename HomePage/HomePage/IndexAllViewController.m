//
//  IndexAllViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "IndexAllViewController.h"
@interface IndexAllViewController ()

@end

@implementation IndexAllViewController

NSArray *definitions;

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
    // Do any additional setup after loading the view, typically from a nib.
    definitions = [NSArray arrayWithObjects:@"Action potential", @"Anterograde transport", @"Astrocyte", @"Axoaxonic synapse", @"Axodendritic synapse", @"Axon", @"Axon hillock", @"Axosomatic synapse", @"Bipolar neuron", @"Chemical synapse", @"Chloroid plexus", @"Dendrite", @"Dendritic tree", @"Dorsal horn of gray matter", @"Dorsal root ganglion", @"Electrical synapse", @"Ependymal cells", @"Ganglia", @"Gap junctions", @"Gray Matter", @"Microglia", @"Multipolar neuron", @"Neuroglial cells", @"Neuron cell body (perikaryon)", @"Neurotransmitters", @"Nissl bodies", @"Oligodendrocytes", @"Pseudounipolar neuron", @"Retrograde transport",@"Satellite cells", @"Schwann cells", @"Synapse", @"Ventral horn of gray matter", @"White matter", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [definitions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indexTableIdentifier = @"IndexTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexTableIdentifier];
    }
    
    cell.textLabel.text = [definitions objectAtIndex:indexPath.row];
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
