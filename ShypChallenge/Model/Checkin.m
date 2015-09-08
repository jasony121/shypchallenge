//
//  Checkin.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "Checkin.h"

@implementation Checkin

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"venue" : @"venue" };
}

+ (NSValueTransformer *)venueJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Venue class]];
}

@end
