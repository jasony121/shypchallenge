//
//  Venue+Util.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "Venue+Util.h"

@implementation Venue (Util)

- (NSArray *)venuePhotos {
    for (PhotoGroup *photoGroup in self.photos.groups) {
        if ([photoGroup.type isEqualToString:@"venue"]) {
            return photoGroup.items;
        }
    }
    return nil;
}

@end

@implementation Photo (Util)

- (NSURL *)thumbnailURL {
    NSString *s = [NSString stringWithFormat:@"%@%@%@", self.prefix, @"300x300", self.suffix];
    return [NSURL URLWithString:s];
}

@end