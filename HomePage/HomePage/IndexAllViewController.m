//
//  IndexAllViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "IndexAllViewController.h"
#import "ExpandingCell.h"

@interface IndexAllViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IndexAllViewController

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
    
    //Testing expandable cells code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
    
    titleArray = [[NSMutableArray alloc] init];
    NSString *string;
    
    //Create consecutive array of 100 numbers. 1..2..etc.
    for (int ii = 1; ii <= 100; ii++) {
        
        string = [[NSString alloc] initWithFormat:@"Row %i", ii];
        [titleArray addObject:string];
    }
    
    subtitleArray = [[NSArray alloc] initWithObjects:@"Anterior white commisure", @"Anterolateral sulcus", @"Cauda equina", @"Cervical enlargement", @"Clarke's nucleus", @"Conus medullaris", @"Dermatome", @"Dorsal horn of gray matter", @"Dorsal intermediate sulcus", @"Dorsal root", @"Dorsal root ganglion", @"Dorsal rootlets", @"Fasciculus cuneatus", @"Fasciculus gracilis",@"Fasciculus propius", @"Filum terminale", @"Flaccid paralysis", @"Funiculus", @"Fusimotor neurons",@"Intermediolateral cell column", @"Lissauer's tract", @"Lower motor neuron", @"Lumbar cistern", @"Lumbar enlargement", @"Phrenic nucleus", @"Posterolateral sulcus", @"Sacral parasympathetic nucleus", @"Somatotopic", @"Spastic paralysis", @"Spinal accessory nucleus", @"Spinal nerve", @"Substantia gelatinosa", @"Upper motor neuron", @"Ventral horn of gray matter", @"Ventral median fissure", @"Ventral root", @"Ventral rootlets", nil];
    
    textArray = [[NSArray alloc] initWithObjects:@"Thin zone of white matter located dorsal to the ventral median fissure. Consists of nerve fibers crossing over to the contralateral side of the spinal cord.", @"Structural landmark on the spinal cord denoting the location in which the ventral rootlets exit the spinal cord",@"The large bundle of dorsal and ventral nerve roots that continue within the vertebral canal below the termination of the spinal cord within the lumbar cistern",@"Enlarged segment of the spinal cord usually spanning from the fifth cervical level tot hte first thoracic level. The cervical enlargement is involved with innervation of the upper extremities.",@"Rounded collection of interneurons on the medial surface of the posterior horn base between the T1-L3 spinal levels. Main function is as a relay nucleus for information to the cerebellum via the dorsal spinocerebellar tract, such as proprioception.",@"The termination of the spinal cord, which traditionally is located in the adult between vertebral levels L1-L2.",@"A strip of skin that is innervated by a single spinal nerve. C1 is the only spinal nerve without a dermatome.",@"Mainly consists of interneurons and projection neurons. Two prominent parts of the dorsal horn of gray matter are the substantia gelatinosa and the body oof thedorsal horn.",@"Longitudinal groove located in only the cervical and upper thoracic levels of the spinal cord. This denotes the separation of the fasciculus gracilis and fasciculus cuneatus.",@"Shallow narrow groove extending to the gray matter surrounding the central canal.",@"Collection of central axon processes from pseudounipolar neurons within the dorsal root ganglion carrying sensory information. Continues as the dorsal rootlets into the spinal cord.",@"Aggregation of pseudounipolar neurons situated within the dorsal roots. THese are the cell bodies of the primary sensory neurons whose central processes pass into the spinal cord and peripheral processes travel through the spinal nerve.",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1",@"def1", nil];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"expandingCell";
    
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //Later
    if (selectedIndex == indexPath.row) {
        //Do expanded cell stuff
    }
    else {
        //Do closed cell stuff
    }
    
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [textArray objectAtIndex:indexPath.row];
    cell.clipsToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedIndex == indexPath.row) {
        return 200;
    } else {
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //User taps expanded row
    if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //User taps different row
    
    if (selectedIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow: selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //User taps new row with none expanded
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
