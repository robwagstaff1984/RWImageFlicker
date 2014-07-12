//
//  RWImageCollectionView.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/12/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageCollectionView.h"

#define CELL_MARGIN (SCREEN_WIDTH * 0.025)
#define CELL_WIDTH (SCREEN_WIDTH * 0.3)
#define CELL_HEIGHT (SCREEN_WIDTH * 0.3)
#define NUMBER_OF_COLUMNS 3

@implementation RWImageCollectionView

/* Create a 3 x 3 grid collection view based on screen size*/
+(RWImageCollectionView*) imageCollectionViewWithFrame:(CGRect)frame {
    
    RWImageCollectionView* imageCollectionView=[[RWImageCollectionView alloc] initWithFrame:frame collectionViewLayout:[RWImageCollectionView layoutWithFrame:frame]];
    
    imageCollectionView.bounces = YES;
    [imageCollectionView setShowsHorizontalScrollIndicator:NO];
    [imageCollectionView setShowsVerticalScrollIndicator:NO];
    
    return imageCollectionView;
}

+(UICollectionViewFlowLayout*) layoutWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];

    layout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(0,CELL_MARGIN,0,CELL_MARGIN);
    layout.minimumInteritemSpacing = CELL_MARGIN;
    layout.minimumLineSpacing = (frame.size.height - (NUMBER_OF_COLUMNS * CELL_HEIGHT)) / NUMBER_OF_COLUMNS;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, layout.minimumLineSpacing / 2);
    layout.footerReferenceSize = layout.headerReferenceSize;

    return layout;
}

@end
