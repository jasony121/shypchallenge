//
//  NearbyVenuesTableViewController.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyVenuesTableViewController : UITableViewController

- (BOOL)isAuthorizedLocationManagerStatus:(CLAuthorizationStatus)status;

@end
