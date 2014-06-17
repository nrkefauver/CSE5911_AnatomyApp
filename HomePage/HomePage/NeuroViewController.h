//
//  NeuroViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface NeuroViewController : UIViewController{
    UIImageView* imageView;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;

enum NeuroImageSelected {
    cervicalScan,
    cervicalDrawing,
    thoracicScan,
    thoracicDrawing,
    lumbarScan,
    lumbarDrawing,
    sacralScan,
    sacralDrawing
};

- (IBAction) contentModeChanged: (UISegmentedControl*)segmentedControl;

@end
