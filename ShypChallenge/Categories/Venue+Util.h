//
//  Venue+Util.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "Venue.h"

@interface Venue (Util)

- (NSArray *)venuePhotos;

@end

@interface Photo (Util)

- (NSURL *)thumbnailURL;

@end
