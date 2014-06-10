//
//  SRExpandableTableViewController.h
//  ExpandableTableViewExample
//
//  Created by Scot Reichman on 8/8/13.
//  Copyright (c) 2013 i2097i. All rights reserved.
//
//  Feel free to use this class however you want. Enjoy!!

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SRExpandableTableViewController : UITableViewController

/**
 *  This is the datasource initialization method.
 *
 *  contentArray should be an instance of NSArray.
 *  Each object in the array should be an array of
 *  objects representing the content in each given
 *  section.
 *
 *  labelsArray is simply an array of strings that
 *  will be used as section labels.
 **/
-(void)setSRExpandableTableViewControllerWithContent:(NSArray *)contentArray andSectionLabels:(NSArray *)labelsArray;

/**
 *  Method for getting the content for a given section.
 *  Use it to get information in the child class
 **/
-(NSArray *)getSectionContentForSection:(NSInteger)section;

/**
 *  Method for hiding or showing the arrows.
 **/
-(void)setArrowsHidden:(BOOL)arrowsHidden;

/**
 *  Method for changing whether or not the tableView
 *  allows multple sections to be opened at the same
 *  time.
 **/
-(void)setMultiExpanded:(BOOL)multiExpanded;

@end
