//
//  FoursquareRequests.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Venue.h"

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@interface FoursquareRequests : NSObject

+ (AFHTTPRequestOperation *)venuesSearchRequestWithLocation:(CLLocation *)location
                                                    success:(void(^)(AFHTTPRequestOperation *operation, NSArray *venues))success
                                                    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)venueDetailRequestWithIdentifier:(NSString *)venueIdentifier
                                                     success:(void(^)(AFHTTPRequestOperation *operation, Venue *venue))success
                                                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)similarVenuesRequestWithIdentifier:(NSString *)venueIdentifier
                                                       success:(void(^)(AFHTTPRequestOperation *operation, NSArray *similarVenues))success
                                                       failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)checkinRequestWithIdentifier:(NSString *)venueIdentifier
                                                 success:(void(^)(AFHTTPRequestOperation *operation, id response))success
                                                 failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)recentCheckinsRequestWithSuccess:(void(^)(AFHTTPRequestOperation *operation, NSArray *checkins))success
                                                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
