//
//  NearbyVenuesTableViewControllerTestCase.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NearbyVenuesTableViewController.h"

@interface NearbyVenuesTableViewControllerTestCase : XCTestCase

@end

@implementation NearbyVenuesTableViewControllerTestCase

- (void)testIsAuthorizedLocationManagerStatus {
    NearbyVenuesTableViewController *vc = [[NearbyVenuesTableViewController alloc] init];
    
    XCTAssert([vc isAuthorizedLocationManagerStatus:kCLAuthorizationStatusAuthorizedWhenInUse]);
    XCTAssert([vc isAuthorizedLocationManagerStatus:kCLAuthorizationStatusAuthorized]);
    XCTAssert(![vc isAuthorizedLocationManagerStatus:kCLAuthorizationStatusDenied]);
    XCTAssert(![vc isAuthorizedLocationManagerStatus:kCLAuthorizationStatusNotDetermined]);
    XCTAssert(![vc isAuthorizedLocationManagerStatus:kCLAuthorizationStatusRestricted]);
}

@end
