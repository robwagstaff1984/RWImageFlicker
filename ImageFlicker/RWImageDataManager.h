//
//  RWImageDataManager.h
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RWImageDataManagerDelegate <NSObject>

@required
- (void) didRetrieveImageUrls;
@end


@interface RWImageDataManager : NSObject

@property (nonatomic, strong) NSCache* cache;
@property (nonatomic, strong) NSString* currentSearchTerm;
@property (nonatomic, assign) int currentSearchCount;

@property (nonatomic, weak) id <RWImageDataManagerDelegate> delegate;

+(RWImageDataManager*) sharedImageDataManager;

-(void)retrieveImagesWithSearchTerm:(NSString*) searchTerm;

@end
