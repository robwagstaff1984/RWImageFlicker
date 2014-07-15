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

#define REUSE_IDENTIFIER @"imageCellIdentifier"

@interface RWImageFlickerViewController ()

@property (nonatomic, strong) RWImageCollectionView *imageCollectionView;
@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation RWImageFlickerViewController

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [RWImageDataManager sharedImageDataManager].delegate = self;
    [[RWImageDataManager sharedImageDataManager] retrieveImagesWithSearchTerm:@"rob"];
    
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupSearch];
    [self setupCollectionView];
}


#pragma mark - setup
-(void) setupSearch{
    self.searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 40)];
    self.searchBar.placeholder = @"Search for images";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

-(void) setupCollectionView
{
    self.imageCollectionView = [RWImageCollectionView imageCollectionViewWithFrame:[self collectionViewFrame]];
    [self.imageCollectionView setDataSource:self];
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:REUSE_IDENTIFIER];
    self.imageCollectionView.backgroundColor = [UIColor redColor];

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
    int currentSearchCount = [[RWImageDataManager sharedImageDataManager] currentSearchCount];
    return currentSearchCount - currentSearchCount % 3;
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

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [[RWImageDataManager sharedImageDataManager] retrieveImagesWithSearchTerm:searchBar.text];
}

#pragma mark - RWImageDataManagerDelegate
-(void) didRetrieveImageUrls {
    NSLog(@"delegate was called");
    if([[RWImageDataManager sharedImageDataManager] currentSearchCount] < 9) {
        [[RWImageDataManager sharedImageDataManager] retrieveImagesWithSearchTerm:[RWImageDataManager sharedImageDataManager].currentSearchTerm];
    } else {
        [self.imageCollectionView reloadData];
    }
}

@end
