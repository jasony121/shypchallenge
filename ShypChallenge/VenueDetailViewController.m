//
//  VenueDetailViewController.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "VenueDetailViewController.h"

#import "FoursquareRequests.h"
#import "UITableView+NimbusModels.h"
#import "ActionsTableViewCell.h"
#import "FoursquareAuthManager.h"

#import "NimbusModels.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, VenueDetailSection) {
    kVenueDetailSectionPhoto,
    kVenueDetailSectionActions,
    kVenueDetailSectionCore,
    kVenueDetailSectionSimilar,
};

@interface VenueDetailViewController () <NITableViewModelDelegate>

@end

@implementation VenueDetailViewController {
    Venue *_venue;
    NSArray *_similarVenues;
    NIMutableTableViewModel *_model;
    NITableViewActions *_actions;
}

- (instancetype)initWithVenue:(Venue *)venue {
    self = [super init];
    if (self) {
        _venue = venue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _venue.name;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _model = [[NIMutableTableViewModel alloc] initWithDelegate:self];
    self.tableView.dataSource = _model;
    
    // Photo section
    [_model addSectionWithTitle:nil];
    [_model addObject:_venue];
    
    // Actions section
    [_model addSectionWithTitle:nil];
    [_model addObject:_venue];
    
    // Core Section
    [_model addSectionWithTitle:nil];
    [_model addObject:_venue];
    
    // Open a new detail page when a similar venue is pressed
    _actions = [[NITableViewActions alloc] init];
    [_actions attachToObject:_venue tapBlock:NULL];
    [_actions attachToClass:[Venue class] tapBlock:^BOOL(Venue *venue, id target, NSIndexPath *indexPath) {
        VenueDetailViewController *vc = [[VenueDetailViewController alloc] initWithVenue:venue];
        [self.navigationController pushViewController:vc animated:YES];
        return YES;
    }];
    self.tableView.delegate = [_actions forwardingTo:self];
    
    if (!_venue.photos) {
        // Need to load the details
        [FoursquareRequests venueDetailRequestWithIdentifier:_venue.identifier success:^(AFHTTPRequestOperation *operation, Venue *venue) {
            _venue = venue;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kVenueDetailSectionPhoto] withRowAnimation:UITableViewRowAnimationNone];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    if (!_similarVenues) {
        [FoursquareRequests similarVenuesRequestWithIdentifier:_venue.identifier success:^(AFHTTPRequestOperation *operation, NSArray *similarVenues) {
            _similarVenues = similarVenues;
            [self maybeAddSimilarSection];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else {
        [self maybeAddSimilarSection];
    }
    
    [self.tableView reloadData];
}

- (void)maybeAddSimilarSection {
    if (_similarVenues.count > 0) {
        [_model addSectionWithTitle:@"You might also like"];
        [_model addObjectsFromArray:_similarVenues];
        
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:kVenueDetailSectionSimilar] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    NSString *nibName;
    
    switch (indexPath.section) {
        case kVenueDetailSectionPhoto:
            nibName = @"PhotosTableViewCell";
            break;
        case kVenueDetailSectionActions: {
            nibName = @"ActionsTableViewCell";
            ActionsTableViewCell *cell = [tableView cellWithNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] indexPath:indexPath object:_venue];
            [cell.directionsButton addTarget:self action:@selector(directionsPressed) forControlEvents:UIControlEventTouchUpInside];
            [cell.callButton addTarget:self action:@selector(callPressed) forControlEvents:UIControlEventTouchUpInside];
            [cell.checkinButton addTarget:self action:@selector(checkinPressed) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        case kVenueDetailSectionCore:
            nibName = @"CoreTableViewCell";
            break;
    }
    
    if (nibName) {
        return [tableView cellWithNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] indexPath:indexPath object:_venue];
    } else {
        return [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kVenueDetailSectionPhoto:
            return [UIScreen mainScreen].bounds.size.width / 3;
        case kVenueDetailSectionActions:
            return 60;
        case kVenueDetailSectionCore:
            return 94;
        case kVenueDetailSectionSimilar:
        default:
            return 44;
    }
}

- (void)directionsPressed {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_venue.location.lat.doubleValue, _venue.location.lng.doubleValue);

    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    destination.name = _venue.name;
    
    [destination openInMapsWithLaunchOptions:nil];
}

- (void)callPressed {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _venue.contact.phone]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)checkinPressed {
    FoursquareAuthManager *manager = [FoursquareAuthManager sharedManager];
    if (manager.authenticated) {
        [FoursquareRequests checkinRequestWithIdentifier:_venue.identifier success:^(AFHTTPRequestOperation *operation, id response) {
            NSString *message = [NSString stringWithFormat:@"Successfully checked in to %@!", _venue.name];
            [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Error. Failed to check in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    } else {
        [manager showSignInDialog];
    }
}

@end
