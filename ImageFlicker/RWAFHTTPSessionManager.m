//
//  RWAFHTTPSessionManager.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//
#define IMAGE_SEARCH_BASE_URL [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/search"]
#define IMAGE_SEARCH_RELATIVE_URL @"images"
#define PARAM_VERSION @"v"
#define PARAM_RESULTS_SIZE @"rsz"
#define PARAM_QUERY @"q"
#define PARAM_OFFSET @"start"

#import "RWAFHTTPSessionManager.h"
#import "RWImageResult.h"

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
        
        NSArray* imageResults = [self extractImageUrlsFromImageSearchResponse:responseObject];
        if ([imageResults count] && successBlock) {
            successBlock(imageResults);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failed to retrieve images results for: %@\nError:\n%@", searchTerm, error);
    }];
}

-(NSDictionary*) paramatersForImageSearchTerm:(NSString*)searchTerm offset:(int)offset{
    return @{PARAM_VERSION: @"1.0", PARAM_RESULTS_SIZE : @"8", PARAM_QUERY : searchTerm, PARAM_OFFSET : [NSString stringWithFormat:@"%d", offset]};
}

-(NSArray*) extractImageUrlsFromImageSearchResponse:(id)imageSearchResponse {
    NSDictionary* responseData = imageSearchResponse[@"responseData"];
    if (responseData!= (id)[NSNull null]) {
        return [self convertToImageResultsFromResults:responseData[@"results"]];
    }
    NSLog(@"Error extracting image URLS");
    return nil;
}

-(NSArray*) convertToImageResultsFromResults:(NSDictionary*)results {
    NSMutableArray* imageResults = [NSMutableArray new];
    for (NSDictionary* result in results) {
        RWImageResult* imageResult = [RWImageResult new];
        imageResult.imageURL = [NSURL URLWithString:result[@"url"]];
        [imageResults addObject:imageResult];
    }
    return imageResults;
}

@end


