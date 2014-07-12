//
//  RWImageFlickerViewController
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageFlickerViewController.h"

#define REUSE_IDENTIFIER @"imageCellIdentifier"
#define CELL_MARGIN (SCREEN_WIDTH * 0.025)
#define CELL_WIDTH (SCREEN_WIDTH * 0.3)
#define CELL_HEIGHT (SCREEN_WIDTH * 0.3)

@interface RWImageFlickerViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RWImageFlickerViewController

#pragma mark - view lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupCollectionView];
    [super viewDidLoad];
}


#pragma mark - setup
-(void) setupCollectionView
{
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
//    layout.minimumLineSpacing = 50;
//    layout.minimumInteritemSpacing = 0;
//    [self.flowLayout setItemSize:CGSizeMake(191, 160)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(CELL_MARGIN,CELL_MARGIN,CELL_MARGIN,CELL_MARGIN);
    
    
    CGRect collectionViewFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height - 100);
    self.collectionView=[[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:REUSE_IDENTIFIER];
    [self.collectionView setBackgroundColor:[UIColor redColor]];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor=[UIColor greenColor];
    } else {
        cell.backgroundColor=[UIColor blueColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
}


@end
