//
//  RWImageDataManager.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageDataManager.h"
#import "RWAFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "RWImageResult.h"
#import "RWSearchResult.h"

@implementation RWImageDataManager

+(RWImageDataManager*) sharedImageDataManager {
    
    static RWImageDataManager* _sharedImageDataManager;
    if(!_sharedImageDataManager) {
        _sharedImageDataManager = [self new];
        _sharedImageDataManager.cache = [[NSCache alloc] init];
    }
    return _sharedImageDataManager;
}

-(void)retrieveMoreImages {
    [self retrieveImagesWithSearchTerm:self.currentSearchTerm];
}

-(void)retrieveImagesWithSearchTerm:(NSString*) searchTerm {
    self.currentSearchTerm = searchTerm;
    
    [[RWAFHTTPSessionManager sharedSessionManager] searchForImageWith:searchTerm offset:[self currentSearchCount] withSuccess:^(NSArray *imageResults) {
        [self updateCacheWithImageResults:imageResults];
        [self notifyDelegateOfNewMetaData:imageResults];
        [self downloadImagesInTheBackgroundFor:imageResults];
    }];
}

-(void) updateCacheWithImageResults:(NSArray*)newImageResults {
    
    RWSearchResult* searchResult = [self currentSearchResult] ?: [RWSearchResult new];
    
    NSMutableArray* cachedImageResults = searchResult.imageResults;
    [cachedImageResults addObjectsFromArray:newImageResults];
    
    searchResult.imageResults = cachedImageResults;
    
    [self.cache setObject:searchResult forKey:self.currentSearchTerm];
}

-(void) notifyDelegateOfNewMetaData:(NSArray*)imageResults {
    RWSearchResult* searchResult = [self currentSearchResult];
   
    int indexOfImageMetaData = (int)[searchResult.imageResults indexOfObject:imageResults[0]];
    [self.delegate didRetrieveImageMetaDataAtIndex:indexOfImageMetaData];
}

-(void) downloadImagesInTheBackgroundFor:(NSArray*)imageResults {
    for (RWImageResult* imageResult in imageResults) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
            imageResult.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageResult.imageURL]];
            [self.delegate didRetrieveImageResult:imageResult];
        });
    }
}

#pragma mark - convenience methods
-(int) currentSearchCount {
    return (int)[[self currentSearchResult].imageResults count];
}

-(RWSearchResult*) currentSearchResult {
    return [self.cache objectForKey:self.currentSearchTerm];
}

-(RWImageResult*) currentCacheAtPosition:(int)position {
    return [self currentSearchResult].imageResults[position];
}

-(int) currentCacheIndexOfImageResult:(RWImageResult*) imageResult {
    RWSearchResult* currentSearchResult = [[RWImageDataManager sharedImageDataManager] currentSearchResult];
    return (int)[currentSearchResult.imageResults indexOfObject:imageResult];
}
@end
