//
//  Checkin.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "Mantle.h"

#import "Venue.h"

@interface Checkin : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) Venue *venue;

@end
