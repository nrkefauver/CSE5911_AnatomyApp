//
//  HistologySlide1ViewController.h
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/17/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface HistoSlide1ViewController : UIViewController {
    UIImageView* imageView;
}

@property (weak, nonatomic) IBOutlet UIWebView *HistoWeb;

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic) int histoSlideNumber;
@end
