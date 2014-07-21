//
//  GrossViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface GrossViewController : UIViewController{
    UIImageView* imageView;
}

@property (weak, nonatomic) IBOutlet UIImageView *LabeledImage;
@property (strong, nonatomic) NSString *initialPopupName;
@property (weak, nonatomic) IBOutlet UISwitch *annotations;



@end
