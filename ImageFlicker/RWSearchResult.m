//
//  RWSearchResult.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/15/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWSearchResult.h"

@implementation RWSearchResult

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageResults = [NSMutableArray new];
    }
    return self;
}

@end
