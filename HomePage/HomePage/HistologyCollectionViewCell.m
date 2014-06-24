//
//  HistologyCollectionViewCell.m
//  HomePage
//
//  Created by shelton, xavier james on 6/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//


#import "HistologyCollectionViewCell.h"

@interface HistologyCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HistologyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 1, 1)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.imageView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)prepareForReuse
{
    [self setImage:nil];
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end