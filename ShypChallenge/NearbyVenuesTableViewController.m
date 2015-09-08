//
//  NearbyVenuesTableViewController.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "NearbyVenuesTableViewController.h"

#import "FoursquareRequests.h"
#import "Venue.h"
#import "VenueDetailViewController.h"

#import "NimbusModels.h"
#import <CoreLocation/CoreLocation.h>

@interface NearbyVenuesTableViewController () <CLLocationManagerDelegate>

@end

@implementation NearbyVenuesTableViewController {
    CLLocation *_searchLocation;
    CLLocationManager *_locationManager;
    NITableViewActions *_actions;
    NITableViewModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Bind actions to models
    _actions = [[NITableViewActions alloc] init];
    [_actions attachToClass:[Venue class] tapBlock:^BOOL(Venue *venue, id target, NSIndexPath *indexPath) {
        VenueDetailViewController *vc = [[VenueDetailViewController alloc] initWithVenue:venue];
        [self.navigationController pushViewController:vc animated:YES];
        return YES;
    }];
    self.tableView.delegate = [_actions forwardingTo:self];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if (![self isAuthorizedLocationManagerStatus:[CLLocationManager authorizationStatus]]) {
        [_locationManager requestWhenInUseAuthorization];
    } else {
        [self maybePerformSearch];
    }
}

- (BOOL)isAuthorizedLocationManagerStatus:(CLAuthorizationStatus)status {
    return status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse;
}

- (void)maybePerformSearch {
    if ([self isAuthorizedLocationManagerStatus:[CLLocationManager authorizationStatus]] && _locationManager.location) {
        [self performSearch];
    }
}

- (void)performSearch {
    _searchLocation = _locationManager.location;
    
    [FoursquareRequests venuesSearchRequestWithLocation:_searchLocation success:^(AFHTTPRequestOperation *operation, NSArray *venues) {
        _model = [[NITableViewModel alloc] initWithListArray:venues delegate:(id)[NICellFactory class]];
        self.tableView.dataSource = _model;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self maybePerformSearch];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
}

@end
