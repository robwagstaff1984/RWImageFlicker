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

@implementation RWImageDataManager

+(RWImageDataManager*) sharedImageDataManager {
    
    static RWImageDataManager* _sharedImageDataManager;
    if(!_sharedImageDataManager) {
        _sharedImageDataManager = [self new];
        _sharedImageDataManager.cache = [[NSCache alloc] init];
    }
    return _sharedImageDataManager;
}


-(void)retrieveImagesWithSearchTerm:(NSString*) searchTerm {
    self.currentSearchTerm = searchTerm;
    
    [[RWAFHTTPSessionManager sharedSessionManager] searchForImageWith:searchTerm offset:[self offset] withSuccess:^(NSArray *imageResults) {
        
        [self updateCacheWithImageResults:imageResults];
        [self downloadImagesInTheBackgroundFor:imageResults];
    }];
}

-(void) updateCacheWithImageResults:(NSArray*)imageResults {
    NSArray* cachedImageURLS = [self.cache objectForKey:self.currentSearchTerm] ?: @[];
    cachedImageURLS = [cachedImageURLS arrayByAddingObjectsFromArray:imageResults];
    [self.cache setObject:cachedImageURLS forKey:self.currentSearchTerm];
}

-(void) downloadImagesInTheBackgroundFor:(NSArray*)imageResults {
    for (RWImageResult* imageResult in imageResults) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
            imageResult.imageData = [NSData dataWithContentsOfURL:imageResult.imageURL];
            NSLog(@"image Result");
            int indexOfImage = [[self.cache objectForKey:[self currentSearchTerm]] indexOfObject:imageResult];
            [self.delegate didRetrieveImageAtIndex:indexOfImage];
        });
    }
}

-(int) offset {
    NSOrderedSet* imageUrls = (NSOrderedSet*)[self.cache objectForKey:self.currentSearchTerm];
    return [imageUrls count];
}

-(int) currentSearchCount {
    return [[self.cache objectForKey:self.currentSearchTerm] count];
}

-(RWImageResult*) currentCacheAtPosition:(int)position {
    RWImageResult* imageResult = [[RWImageDataManager sharedImageDataManager].cache objectForKey:[RWImageDataManager sharedImageDataManager].currentSearchTerm][position];
    return imageResult;
}

@end
