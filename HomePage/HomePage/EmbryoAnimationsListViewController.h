//
//  EmbryoAnimationsListViewController.h
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/9/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import <MediaPlayer/MediaPlayer.h>

@interface EmbryoAnimationsListViewController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSString *startUpVideoName;
@property (strong, nonatomic) NSString *startUpVideoType;

- (IBAction)onBurger:(id)sender;
- (IBAction)onNeuralTube001:(id)sender;
- (IBAction)onSampleVideo:(id)sender;

@end
