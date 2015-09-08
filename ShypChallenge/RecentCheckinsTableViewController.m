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

@implementation RecentCheckinsTableViewController {
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
    
    [self performSearch];
}

- (void)performSearch {
    [FoursquareRequests recentCheckinsRequestWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *checkins) {
        NSArray *venues = [self venuesFromCheckins:checkins];
        _model = [[NITableViewModel alloc] initWithListArray:venues delegate:(id)[NICellFactory class]];
        self.tableView.dataSource = _model;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO
    }];
}

- (NSArray *)venuesFromCheckins:(NSArray *)checkins {
    NSMutableArray *venues = [NSMutableArray array];
    for (Checkin *checkin in checkins) {
        [venues addObject:checkin.venue];
    }
    return venues;
}

@end
