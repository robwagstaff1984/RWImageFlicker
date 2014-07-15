//
//  RWAFHTTPSessionManager.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//
#define IMAGE_SEARCH_BASE_URL [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/search"]
#define IMAGE_SEARCH_RELATIVE_URL @"images"

#import "RWAFHTTPSessionManager.h"

@implementation RWAFHTTPSessionManager

+(RWAFHTTPSessionManager*) sharedSessionManager {
    
    static RWAFHTTPSessionManager* _sharedSessionManager;
    if(!_sharedSessionManager) {
        _sharedSessionManager = [[RWAFHTTPSessionManager alloc] initWithBaseURL:IMAGE_SEARCH_BASE_URL];
    }
    return _sharedSessionManager;
}   

-(void) searchForImageWith:(NSString*)searchTerm offset:(int)offset withSuccess:(void(^)(NSArray*))successBlock{
    
    NSDictionary* parameters = [self paramatersForImageSearchTerm:searchTerm offset:offset];
    
    [[RWAFHTTPSessionManager sharedSessionManager] GET:IMAGE_SEARCH_RELATIVE_URL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray* imageURLs = [self extractImageUrlsFromImageSearchResponse:responseObject];
        successBlock(imageURLs);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failed to retrieve images results for: %@\nError:\n%@", searchTerm, error);
    }];
}

-(NSDictionary*) paramatersForImageSearchTerm:(NSString*)searchTerm offset:(int)offset{
    return @{@"v" : @"1.0", @"rsz" : @"8", @"q" : searchTerm, @"start": [NSString stringWithFormat:@"%d", offset]};
}

-(NSArray*) extractImageUrlsFromImageSearchResponse:(id)imageSearchResponse {
    NSDictionary* results = imageSearchResponse[@"responseData"][@"results"];
    
    NSMutableArray* imageURLs = [NSMutableArray new];
    
    for (NSDictionary* result in results) {
        NSURL* imageURL = [NSURL URLWithString:result[@"url"]];
        [imageURLs addObject:imageURL];
    }
    return imageURLs;
}

@end


