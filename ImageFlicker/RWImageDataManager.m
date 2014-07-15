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
    
    [[RWAFHTTPSessionManager sharedSessionManager] searchForImageWith:searchTerm offset:[self offset] withSuccess:^(NSArray *imageUrls) {
        NSArray* cachedImageURLS =  [self.cache objectForKey:searchTerm] ?: @[];
        cachedImageURLS = [cachedImageURLS arrayByAddingObjectsFromArray:imageUrls];
        [self.cache setObject:cachedImageURLS forKey:searchTerm];
        [self.delegate didRetrieveImageUrls];
    }];
}

-(int) offset {
    NSOrderedSet* imageUrls = (NSOrderedSet*)[self.cache objectForKey:self.currentSearchTerm];
    return [imageUrls count];
}

-(int) currentSearchCount {
    return [[self.cache objectForKey:self.currentSearchTerm] count];
}

@end
