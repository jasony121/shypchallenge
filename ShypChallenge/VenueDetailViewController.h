//
//  VenueDetailViewController.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Venue.h"

@interface VenueDetailViewController : UITableViewController

- (instancetype)initWithVenue:(Venue *)venue;

@end
