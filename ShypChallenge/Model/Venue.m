//
//  Venue.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "Venue.h"

#import <UIKit/UIKit.h>

@implementation Venue

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"identifier" : @"id",
              @"location" : @"location",
              @"categories" : @"categories",
              @"photos" : @"photos",
              @"name" : @"name",
              @"contact" : @"contact" };
}

- (UINib *)cellNib {
    return [UINib nibWithNibName:@"VenueTableViewCell" bundle:[NSBundle mainBundle]];
}

+ (NSValueTransformer *)categoriesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[VenueCategory class]];
}

+ (NSValueTransformer *)photosJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Photos class]];
}

+ (NSValueTransformer *)locationJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Location class]];
}

+ (NSValueTransformer *)contactJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Contact class]];
}

@end

@implementation Location

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"lat" : @"lat",
              @"lng" : @"lng",
              @"city" : @"city",
              @"state" : @"state" };
}

@end

@implementation VenueCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"name" : @"name" };
}

@end

@implementation Photos

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"groups" : @"groups" };
}

+ (NSValueTransformer *)groupsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PhotoGroup class]];
}

@end

@implementation PhotoGroup

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"type" : @"type",
              @"items" : @"items" };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Photo class]];
}

@end

@implementation Photo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"identifier" : @"id",
              @"prefix" : @"prefix",
              @"suffix" : @"suffix" };
}

@end

@implementation Contact

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"phone" : @"phone",
              @"formattedPhone" : @"formattedPhone" };
}

@end
