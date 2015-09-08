//
//  CLLocationManager+Simulator.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "CLLocationManager+Simulator.h"

@implementation CLLocationManager (Simulator)

#if TARGET_IPHONE_SIMULATOR
+ (CLAuthorizationStatus)authorizationStatus {
    return kCLAuthorizationStatusAuthorizedWhenInUse;
}

- (CLLocation *)location {
    return [[CLLocation alloc] initWithLatitude:37.778530 longitude:-122.414855];
}
#endif

@end
