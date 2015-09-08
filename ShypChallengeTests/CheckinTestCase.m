//
//  CheckinTestCase.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "KIF.h"

#import "FoursquareAuthManager.h"

@interface FoursquareAuthManager ()

@property (nonatomic, strong) NSString *authToken;

@end

@interface CheckinTestCase : KIFTestCase

@end

@implementation CheckinTestCase

- (void)testCheckinNotSignedIn {
    [[FoursquareAuthManager sharedManager] signOut];
    
    [tester tapViewWithAccessibilityLabel:@"City of San Francisco"];
    [tester tapViewWithAccessibilityLabel:@"Checkin"];
    [tester waitForViewWithAccessibilityLabel:@"Signin Required"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
}

- (void)testCheckinSignedIn {
    [[FoursquareAuthManager sharedManager] setAuthToken:@"M5A5IXMTCDQE5MU5W33CTNBFKMFNB5CN5CSLDWVTCJSJYA4U"];
    
    [tester tapViewWithAccessibilityLabel:@"City of San Francisco"];
    [tester tapViewWithAccessibilityLabel:@"Checkin"];
    [tester waitForViewWithAccessibilityLabel:@"Success"];
    [tester waitForTimeInterval:5];
    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester tapViewWithAccessibilityLabel:@"History"];
    [tester waitForViewWithAccessibilityLabel:@"City of San Francisco"];
    [tester tapViewWithAccessibilityLabel:@"Search"];
    
    [[FoursquareAuthManager sharedManager] signOut];

}

@end
