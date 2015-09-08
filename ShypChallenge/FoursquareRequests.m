//
//  FoursquareRequests.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "FoursquareRequests.h"

#import "Venue.h"
#import "Checkin.h"
#import "FoursquareAuthManager.h"

#import <CoreLocation/CoreLocation.h>

static const NSString *kBaseURL = @"https://api.foursquare.com";
static const NSString *kClientID = @"PAOUBVQIP1ZCN1Y2W30CS10HRB43FGEI2CFUP0O3AZBBZD4Y";
static const NSString *kClientSecret = @"JESSJXKCHLDMSR2UTDHNGL03OBBWHTHHDG4GRBNMZQGB5A3Z";
static const NSString *kVersion = @"20150906";

@implementation FoursquareRequests

+ (AFHTTPRequestOperation *)foursquareRequestWithPath:(NSString *)path
                                               method:(NSString *)method
                                           parameters:(NSDictionary *)parameters
                                              success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                  responseTransformer:(id(^)(id responseObject, NSError **error))responseTransformer {
    NSString *url = [kBaseURL stringByAppendingString:path];
    
    NSMutableDictionary *parametersWithAuthentication = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    FoursquareAuthManager *authManager= [FoursquareAuthManager sharedManager];
    if (authManager.authenticated) {
        [parametersWithAuthentication addEntriesFromDictionary:@{
                                                                 @"oauth_token" : authManager.authToken,
                                                                 @"v" : kVersion
                                                                 }];
    } else {
        [parametersWithAuthentication addEntriesFromDictionary:@{
                                                                 @"client_id" : kClientID,
                                                                 @"client_secret" : kClientSecret,
                                                                 @"v" : kVersion
                                                                 }];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    void(^transformingSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        id transformedResponseObject = responseObject;
        if (responseTransformer) {
            transformedResponseObject = responseTransformer(responseObject, &error);
        }
        if (error) {
            failure(operation, error);
        } else {
            success(operation, transformedResponseObject);
        }
    };
    
    if ([method isEqualToString:@"GET"]) {
        return [manager GET:url parameters:parametersWithAuthentication success:transformingSuccessBlock failure:failure];
    } else {
        return [manager POST:url parameters:parametersWithAuthentication success:transformingSuccessBlock failure:failure];
    }
}

+ (AFHTTPRequestOperation *)venuesSearchRequestWithLocation:(CLLocation *)location
                                                    success:(void(^)(AFHTTPRequestOperation *operation, NSArray *venues))success
                                                    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = @"/v2/venues/search";
    NSString *ll = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    
    return [self foursquareRequestWithPath:path
                                    method:@"GET"
                                parameters:@{ @"ll" : ll }
                                   success:success
                                   failure:failure
                       responseTransformer:^id(id responseObject, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[Venue class] fromJSONArray:responseObject[@"response"][@"venues"] error:error];
    }];
}

+ (AFHTTPRequestOperation *)venueDetailRequestWithIdentifier:(NSString *)venueIdentifier
                                                     success:(void(^)(AFHTTPRequestOperation *operation, Venue *venue))success
                                                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"/v2/venues/%@", venueIdentifier];
    
    return [self foursquareRequestWithPath:path
                                    method:@"GET"
                                parameters:@{}
                                   success:success
                                   failure:failure
                       responseTransformer:^id(id responseObject, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[Venue class] fromJSONDictionary:responseObject[@"response"][@"venue"] error:error];
    }];
}

+ (AFHTTPRequestOperation *)similarVenuesRequestWithIdentifier:(NSString *)venueIdentifier
                                                       success:(void(^)(AFHTTPRequestOperation *operation, NSArray *similarVenues))success
                                                       failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"/v2/venues/%@/similar", venueIdentifier];
    
    return [self foursquareRequestWithPath:path
                                    method:@"GET"
                                parameters:@{}
                                   success:success
                                   failure:failure
                       responseTransformer:^id(id responseObject, NSError *__autoreleasing *error) {
       return [MTLJSONAdapter modelsOfClass:[Venue class] fromJSONArray:responseObject[@"response"][@"similarVenues"][@"items"] error:error];
    }];
}

+ (AFHTTPRequestOperation *)checkinRequestWithIdentifier:(NSString *)venueIdentifier
                                                 success:(void(^)(AFHTTPRequestOperation *operation, id response))success
                                                 failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = @"/v2/checkins/add";
    
    return [self foursquareRequestWithPath:path
                                    method:@"POST"
                                parameters:@{ @"venueId" : venueIdentifier }
                                   success:success
                                   failure:failure
                       responseTransformer:nil];
}

+ (AFHTTPRequestOperation *)recentCheckinsRequestWithSuccess:(void(^)(AFHTTPRequestOperation *operation, NSArray *checkins))success
                                                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = @"/v2/users/self/checkins";
    
    return [self foursquareRequestWithPath:path
                                    method:@"GET"
                                parameters:@{}
                                   success:success
                                   failure:failure
                       responseTransformer:^id(id responseObject, NSError *__autoreleasing *error) {
       return [MTLJSONAdapter modelsOfClass:[Checkin class] fromJSONArray:responseObject[@"response"][@"checkins"][@"items"] error:error];
    }];
}

@end
