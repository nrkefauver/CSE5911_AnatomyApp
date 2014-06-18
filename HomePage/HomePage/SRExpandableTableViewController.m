//
//  SRExpandableTableViewController.m
//  ExpandableTableViewExample
//
//  Created by Scot Reichman on 8/8/13.
//  Copyright (c) 2013 i2097i. All rights reserved.
//

#import "SRExpandableTableViewController.h"

#define HEADER_BACKGROUND_COLOR [UIColor lightGrayColor]
#define HEADER_BORDER_COLOR [[UIColor whiteColor]CGColor]
#define HEADER_FONT [UIFont boldSystemFontOfSize:17]
#define HEADER_FONT_COLOR [UIColor blackColor]

const float headerHeight = 30.0f;
const float headerLabelInset = 10.0f;
const float headerBorderWidth = 1.0f;
const float headerArrowInset = 20.0f;
const float footerHeight = 0.0f;

@interface SRExpandableTableViewController ()

@property (strong, nonatomic) NSArray *sectionLabels;
@property (strong, nonatomic) NSArray *sectionContent;
@property (strong, nonatomic) NSMutableArray *expandedSectionContent;
@property (strong, nonatomic) NSMutableArray *collapsedSectionContent;
@property NSInteger expandedSection;
@property BOOL arrowsVisible;
@property BOOL allowsMultipleExpanded;

@end

@implementation SRExpandableTableViewController
@synthesize sectionLabels,sectionContent,expandedSectionContent,collapsedSectionContent,arrowsVisible,allowsMultipleExpanded,expandedSection;

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionLabels objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionLabels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.expandedSectionContent objectAtIndex:section] count];
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return headerHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return footerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getTableViewHeaderViewForSection:section];
}

#pragma mark - SRExpandableTableViewController custom methods

-(void)setSRExpandableTableViewControllerWithContent:(NSArray *)contentArray andSectionLabels:(NSArray *)labelsArray
{
    self.sectionContent = contentArray;
    self.sectionLabels = labelsArray;
    if(!sectionContent)
    {
        self.sectionContent = [NSArray array];
    }
    if(!sectionLabels)
    {
        self.sectionLabels = [NSArray array];
    }
    
    [self setupContentArrays];
    
    [self.tableView reloadData];
    
}

-(NSArray *)getSectionContentForSection:(NSInteger)section
{
    return [self.sectionContent objectAtIndex:section];
}

-(void)setMultiExpanded:(BOOL)multiExpanded
{
    self.allowsMultipleExpanded = multiExpanded;
    [self setupContentArrays];
    [self.tableView reloadData];
}

-(void)setArrowsHidden:(BOOL)arrowsHidden
{
    self.arrowsVisible = !arrowsHidden;
    [self.tableView reloadData];
}

-(void)headerTapped:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *tappedView = tap.view;
    NSLog(@"header with tag %i was tapped",tappedView.tag);
    if([[self.sectionContent objectAtIndex:tappedView.tag]count] == 0)
    {
        // No Content in selected section
    }
    else if([[self.expandedSectionContent objectAtIndex:tappedView.tag] count] == 0)
    {
        // Collapsed
        [self expandSection:tappedView.tag withReload:YES];
    }
    else
    {
        // Expanded
        [self closeSection:tappedView.tag];
    }
}

-(void)setupContentArrays
{
    if(self.allowsMultipleExpanded)
    {
        self.expandedSectionContent = [NSMutableArray arrayWithArray:[self.sectionContent copy]];
        self.collapsedSectionContent = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.sectionContent.count; i++)
        {
            // Add placeholder to represent empty sections
            [self.collapsedSectionContent addObject:[[NSArray alloc]init]];
        }
    }
    else
    {
        self.collapsedSectionContent = [NSMutableArray arrayWithArray:[self.sectionContent copy]];
        self.expandedSectionContent = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.sectionContent.count; i++)
        {
            // Add placeholder to represent empty sections
            [self.expandedSectionContent addObject:[[NSArray alloc]init]];
        }
        self.expandedSection = 0;
        [self expandSection:0 withReload:NO];
    }
}

-(void)closeSection:(NSInteger)section
{
	NSMutableArray *arrayToClose = [self.expandedSectionContent objectAtIndex:section];
	NSMutableArray *placeholderArray = [self.collapsedSectionContent objectAtIndex:section];
	if(placeholderArray.count == 0)
	{
		[self.collapsedSectionContent replaceObjectAtIndex:section withObject:arrayToClose];
		[self.expandedSectionContent replaceObjectAtIndex:section withObject:placeholderArray];
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

-(void)expandSection:(NSInteger)section withReload:(BOOL)reload
{
	NSMutableArray *arrayToExpand = [self.collapsedSectionContent objectAtIndex:section];
    NSMutableArray *placeholderArray = [self.expandedSectionContent objectAtIndex:section];
    
	if(placeholderArray.count == 0)
	{
        if(!self.allowsMultipleExpanded)
        {
            [self closeSection:self.expandedSection];
        }
        self.expandedSection = section;
		[self.expandedSectionContent replaceObjectAtIndex:section withObject:arrayToExpand];
		[self.collapsedSectionContent replaceObjectAtIndex:section withObject:placeholderArray];
		
		if(reload)
		{
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
}

-(UIView *)getTableViewHeaderViewForSection:(NSInteger)section
{
    CGRect viewFrame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, headerHeight);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    if(self.tableView.style == UITableViewStylePlain)
    {
        [view setBackgroundColor:HEADER_BACKGROUND_COLOR];
    }
    else
    {
        [view setBackgroundColor:[UIColor clearColor]];
    }
    [view.layer setBorderColor:HEADER_BORDER_COLOR];
    [view.layer setBorderWidth:headerBorderWidth];
    [view setTag:section];
    
    CGRect labelFrame = viewFrame;
    labelFrame.origin.x = headerLabelInset;
    labelFrame.size.width = viewFrame.size.width - headerLabelInset;
    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[self.sectionLabels objectAtIndex:section]];
    [label setFont:HEADER_FONT];
    [label setTextColor:HEADER_FONT_COLOR];
    [label setTextAlignment:NSTextAlignmentLeft];
    [view addSubview:label];
    
    if(self.arrowsVisible)
    {
        CGRect imageViewFrame = viewFrame;
        imageViewFrame.size.width = headerHeight/2;
        imageViewFrame.size.height = headerHeight/2;
        imageViewFrame.origin.x = viewFrame.size.width - headerArrowInset;
        imageViewFrame.origin.y = headerHeight/4;
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setFrame:imageViewFrame];
        UIImage *image;
        if([self isSectionExpanded:section])
        {
            image = [UIImage imageNamed:@"arrow_down.png"];
        }
        else
        {
            image = [UIImage imageNamed:@"arrow_left.png"];
        }
        [imageView setImage:image];
        [view addSubview:imageView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapped:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:tap];
    
    return view;
}

-(BOOL)isSectionExpanded:(NSInteger)section
{
    return [[self.collapsedSectionContent objectAtIndex:section] count] == 0 || [[self.expandedSectionContent objectAtIndex:section]count] > 0 || [[self.sectionContent objectAtIndex:section]count] == 0;
}

@end