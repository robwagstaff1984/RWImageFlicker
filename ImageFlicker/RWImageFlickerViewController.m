//
//  RWImageFlickerViewController
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageFlickerViewController.h"
#import "RWImageCollectionView.h"
#import "RWImageDataManager.h"
#import "RWImageCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"

#define REUSE_IDENTIFIER @"imageCellIdentifier"
#define SEARCH_BAR_TEXT @"Search for images";

@interface RWImageFlickerViewController ()

@property (nonatomic, strong) RWImageCollectionView *imageCollectionView;
@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation RWImageFlickerViewController

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RWImageDataManager sharedImageDataManager].delegate = self;
    [[RWImageDataManager sharedImageDataManager] retrieveImagesWithSearchTerm:@"Rob"];

    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupSearch];
    [self setupCollectionView];
}


#pragma mark - setup
-(void) setupSearch{
    self.searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 40)];
    self.searchBar.placeholder = SEARCH_BAR_TEXT;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

-(void) setupCollectionView
{
    self.imageCollectionView = [RWImageCollectionView imageCollectionViewWithFrame:[self collectionViewFrame]];
    [self.imageCollectionView setDataSource:self];
    [self.imageCollectionView setDelegate:self];
    [self.imageCollectionView registerClass:[RWImageCell class] forCellWithReuseIdentifier:REUSE_IDENTIFIER];

    [self.view addSubview:self.imageCollectionView];
}

-(CGRect) collectionViewFrame {
    int yPosition =  self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
    int height = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.searchBar.frame.size.height;
    CGRect collectionViewFrame = CGRectMake(0, yPosition, SCREEN_WIDTH, height);
    return collectionViewFrame;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[RWImageDataManager sharedImageDataManager] currentSearchCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWImageCell *imageCell=[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    
    RWImageResult* imageResult = [[RWImageDataManager sharedImageDataManager] currentCacheAtPosition:(int)indexPath.row];
    
    if (imageResult.image) {
        [imageCell stopSpinner];
        imageCell.imageView.image = imageResult.image;
    } else {
        [imageCell startSpinner];
    }
    
    return imageCell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[RWImageDataManager sharedImageDataManager] currentSearchCount] - 1) {
        NSLog(@"infinite scroll");
        [[RWImageDataManager sharedImageDataManager] retrieveMoreImages];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ((RWImageCell*)cell).imageView.image = nil;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [[RWImageDataManager sharedImageDataManager] retrieveImagesWithSearchTerm:searchBar.text];
}

#pragma mark - RWImageDataManagerDelegate
- (void) didRetrieveImageResult:(RWImageResult*)imageResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int indexOfImage = [[RWImageDataManager sharedImageDataManager] currentCacheIndexOfImageResult:imageResult];
        NSLog(@"%d", indexOfImage);
        
        [self.imageCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexOfImage inSection:0]]];
    });
}

- (void) didRetrieveImageMetaDataAtIndex:(int)index {
    [self.imageCollectionView reloadData];
}

@end
