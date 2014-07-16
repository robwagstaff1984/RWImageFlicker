//
//  RWImageCell.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageCell.h"
#import "MBProgressHUD.h"

@interface RWImageCell()

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;

@end

@implementation RWImageCell

- (instancetype)initWithFrame:(CGRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        [self setupSpinner];
    }
    return self;
}

-(void) setupSpinner {
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.activityIndicatorView.color = [UIColor whiteColor];
    [self addSubview:self.activityIndicatorView];
    
    self.activityIndicatorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

-(void) startSpinner {
    [self.activityIndicatorView startAnimating];
}

-(void) stopSpinner {
    [self.activityIndicatorView stopAnimating];
}

@end
