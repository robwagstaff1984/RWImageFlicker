//
//  RWImageCollectionView.h
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/12/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWImageCollectionView : UICollectionView

//TODO should this be a class method? should it be an init
+(RWImageCollectionView*) imageCollectionViewWithFrame:(CGRect)frame;

@end
