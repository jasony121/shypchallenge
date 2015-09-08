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
    BOOL _searching;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.accessibilityLabel = @"Search Table";
    self.tableView.isAccessibilityElement = YES;
    
    // Bind actions to models
    _actions = [[NITableViewActions alloc] init];
    [_actions attachToClass:[Venue class] tapBlock:^BOOL(Venue *venue, id target, NSIndexPath *indexPath) {
        VenueDetailViewController *vc = [[VenueDetailViewController alloc] initWithVenue:venue];
        [self.navigationController pushViewController:vc animated:YES];
        return YES;
    }];
    self.tableView.delegate = [_actions forwardingTo:self];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [self performSearchOrShowErrorOrRequestLocationServicesAuthorization];
}

- (void)performSearchOrShowErrorOrRequestLocationServicesAuthorization {
    if (![self isAuthorizedLocationManagerStatus:[CLLocationManager authorizationStatus]]) {
        [self disableRefreshControlAndShowErrorMessage];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            } else {
                [_locationManager startUpdatingLocation];
            }
        }
    } else {
        [_locationManager startUpdatingLocation];
        [self maybePerformSearch];
    }
}

- (BOOL)isAuthorizedLocationManagerStatus:(CLAuthorizationStatus)status {
    return status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse;
}

- (void)maybePerformSearch {
    if (![self isAuthorizedLocationManagerStatus:[CLLocationManager authorizationStatus]] || !_locationManager.location) {
        return;
    }
    
    if (_searchLocation && [_searchLocation distanceFromLocation:_locationManager.location] < 100) {
        return;
    }
    
    [self enableRefreshControlAndHideErrorMessage];
    
    _searching = YES;
    _searchLocation = _locationManager.location;
    [self.refreshControl beginRefreshing];
    
    [FoursquareRequests venuesSearchRequestWithLocation:_searchLocation success:^(AFHTTPRequestOperation *operation, NSArray *venues) {
        _model = [[NITableViewModel alloc] initWithListArray:venues delegate:(id)[NICellFactory class]];
        self.tableView.dataSource = _model;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        _searching = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        _searching = NO;
    }];
}

- (void)enableRefreshControlAndHideErrorMessage {
    if (!self.refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
        self.tableView.tableHeaderView = [[UIView alloc] init];
    }
}

- (void)disableRefreshControlAndShowErrorMessage {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"This application requires access to Location Services";
    
    CGRect rect = self.tableView.bounds;
    rect.size.height = 200;
    label.frame = rect;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    self.refreshControl = nil;
    
    self.tableView.dataSource = nil;
    [self.tableView reloadData];
}

- (void)refreshControlValueChanged {
    if (self.refreshControl.refreshing && !_searching) {
        // Force refresh
        _searchLocation = nil;
        [self maybePerformSearch];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([self isAuthorizedLocationManagerStatus:status]) {
        [_locationManager startUpdatingLocation];
    }
    [self performSearchOrShowErrorOrRequestLocationServicesAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    if (self.tableView.contentOffset.y < 100) {
        [self maybePerformSearch];
    }
}

@end
