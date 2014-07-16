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

#define COLLECTION_VIEW_REUSE_IDENTIFIER @"imageCellIdentifier"
#define TABLE_VIEW_REUSE_IDENTIFIER @"searchHistoryIdentifier"
#define SEARCH_BAR_TEXT @"Search for images";

@interface RWImageFlickerViewController ()

@property (nonatomic, strong) RWImageCollectionView *imageCollectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView* searchHistoryTableView;
@property (nonatomic, strong) NSMutableOrderedSet* searchHistory;

@end

@implementation RWImageFlickerViewController

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RWImageDataManager sharedImageDataManager].delegate = self;

    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupSearch];
    [self setupCollectionView];
    [self setupTableView];
    self.searchHistory = [NSMutableOrderedSet new];
}


#pragma mark - setup
-(void) setupSearch {
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
    [self.imageCollectionView registerClass:[RWImageCell class] forCellWithReuseIdentifier:COLLECTION_VIEW_REUSE_IDENTIFIER];
    [self.imageCollectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearch)]];

    [self.view addSubview:self.imageCollectionView];
}

-(CGRect) collectionViewFrame {
    int yPosition =  self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
    int height = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - self.searchBar.frame.size.height;
    CGRect collectionViewFrame = CGRectMake(0, yPosition, SCREEN_WIDTH, height);
    return collectionViewFrame;
}

-(void) setupTableView {
    self.searchHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.imageCollectionView.frame.origin.y, SCREEN_WIDTH, 0)];
    [self.searchHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TABLE_VIEW_REUSE_IDENTIFIER];
    self.searchHistoryTableView.dataSource = self;
    self.searchHistoryTableView.delegate = self;
    self.searchHistoryTableView.scrollEnabled = false;
    [self.view addSubview:self.searchHistoryTableView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[RWImageDataManager sharedImageDataManager] currentSearchCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWImageCell *imageCell=[collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_VIEW_REUSE_IDENTIFIER forIndexPath:indexPath];
    
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
        [[RWImageDataManager sharedImageDataManager] retrieveMoreImages];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ((RWImageCell*)cell).imageView.image = nil;
}

#pragma mark - UISearchBarDelegate
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self showSearch];
    [self.searchHistoryTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self closeSearch];
    [self updateSearchHistory];
    
    [[RWImageDataManager sharedImageDataManager] retrieveImagesWithSearchTerm:searchBar.text];
}

-(void) updateSearchHistory {
    if ([self.searchHistory containsObject:self.searchBar.text]) {
        [self.searchHistory removeObject:self.searchBar.text];
    }
    [self.searchHistory insertObject:self.searchBar.text atIndex:0];
}

-(void)showSearch {
    self.searchHistoryTableView.frame = CGRectMake(self.searchHistoryTableView.frame.origin.x, self.searchHistoryTableView.frame.origin.y,self.searchHistoryTableView.frame.size.width, MIN(4, [self.searchHistory count]) * 44);
    self.searchHistoryTableView.hidden = false;
}

-(void)closeSearch {
    [self.searchBar resignFirstResponder];
    self.searchHistoryTableView.hidden = true;
}

#pragma mark - RWImageDataManagerDelegate
- (void) didRetrieveImageResult:(RWImageResult*)imageResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        int indexOfImage = [[RWImageDataManager sharedImageDataManager] currentCacheIndexOfImageResult:imageResult];
        if (indexOfImage > 0) {
            [self.imageCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexOfImage inSection:0]]];
        }
    });
}

- (void) didRetrieveImageMetaDataAtIndex:(int)index {
    [self.imageCollectionView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = self.searchHistory[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* previousSearch = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    self.searchBar.text = previousSearch;
    [self searchBarSearchButtonClicked:self.searchBar];
}

@end
