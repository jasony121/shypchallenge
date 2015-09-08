//
//  RecentCheckinsTableViewController.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "RecentCheckinsTableViewController.h"

#import "Venue.h"
#import "Checkin.h"
#import "VenueDetailViewController.h"
#import "FoursquareRequests.h"

#import "NimbusModels.h"

@interface RecentCheckinsTableViewController ()

@end

@implementation RecentCheckinsTableViewController {
    NITableViewActions *_actions;
    NITableViewModel *_model;
    BOOL _searching;
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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self performSearch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Nasty hack to fix this view controller laying out underneath the navigation bar
    [self.navigationController.view setNeedsLayout];
}

- (void)performSearch {
    _searching = YES;
    [self.refreshControl beginRefreshing];
    [FoursquareRequests recentCheckinsRequestWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *checkins) {
        NSArray *venues = [self venuesFromCheckins:checkins];
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

- (NSArray *)venuesFromCheckins:(NSArray *)checkins {
    NSMutableArray *venues = [NSMutableArray array];
    for (Checkin *checkin in checkins) {
        [venues addObject:checkin.venue];
    }
    return venues;
}

- (void)refreshControlValueChanged {
    if (self.refreshControl.refreshing && !_searching) {
        [self performSearch];
    }
}

@end
