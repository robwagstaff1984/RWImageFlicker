//
//  RWImageDataManager.h
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWImageResult.h"
#import "RWSearchResult.h"

@protocol RWImageDataManagerDelegate <NSObject>

@required
- (void) didRetrieveImageResult:(RWImageResult*)imageResult;
- (void) didRetrieveImageMetaDataAtIndex:(int)index;
@end


@interface RWImageDataManager : NSObject

@property (nonatomic, strong) NSCache* cache;
@property (nonatomic, strong) NSString* currentSearchTerm;



@property (nonatomic, weak) id <RWImageDataManagerDelegate> delegate;

+(RWImageDataManager*) sharedImageDataManager;

-(void)retrieveImagesWithSearchTerm:(NSString*) searchTerm;
-(void)retrieveMoreImages;

-(int) currentSearchCount;
-(RWSearchResult*) currentSearchResult;
-(RWImageResult*) currentCacheAtPosition:(int)position;
-(int) currentCacheIndexOfImageResult:(RWImageResult*) imageResult;

@end
