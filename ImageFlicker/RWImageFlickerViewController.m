//
//  RWImageFlickerViewController
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageFlickerViewController.h"
#import "RWImageCollectionView.h"

#define REUSE_IDENTIFIER @"imageCellIdentifier"

@interface RWImageFlickerViewController ()

@property (nonatomic, strong) RWImageCollectionView *imageCollectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation RWImageFlickerViewController

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupSearch];
    [self setupCollectionView];
    [super viewDidLoad];
}


#pragma mark - setup
-(void) setupSearch{
    self.searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 40)];
    self.searchBar.placeholder = @"Search for images";
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
}

-(void) setupCollectionView
{
    self.imageCollectionView = [RWImageCollectionView imageCollectionViewWithFrame:[self collectionViewFrame]];
    [self.imageCollectionView setDataSource:self];
    [self.imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:REUSE_IDENTIFIER];

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



#pragma mark - search bar 

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   // isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"Text change - %d",isSearching);
//    
//    //Remove all objects first.
//    [filteredContentList removeAllObjects];
//    
//    if([searchText length] != 0) {
//        isSearching = YES;
//        [self searchTableList];
//    }
//    else {
//        isSearching = NO;
//    }
//    // [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
   // [self searchTableList];
}



@end
