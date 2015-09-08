//
//  Venue.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "Mantle.h"

@class Location;
@class Photos;
@class Contact;

@interface Venue : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) Location *location;
@property (nonatomic, strong, readonly) NSArray *categories;
@property (nonatomic, strong, readonly) Photos *photos;
@property (nonatomic, strong, readonly) Contact *contact;

@end

@interface Location : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSNumber *lat;
@property (nonatomic, strong, readonly) NSNumber *lng;
@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *state;

@end

@interface VenueCategory : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *name;

@end

@interface Photos : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSArray *groups;

@end

@interface PhotoGroup : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSArray *items;

@end

@interface Photo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *prefix;
@property (nonatomic, strong, readonly) NSString *suffix;

@end


@interface Contact : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *phone;
@property (nonatomic, strong, readonly) NSString *formattedPhone;

@end
