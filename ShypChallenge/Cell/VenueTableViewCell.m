//
//  VenueTableViewCell.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "VenueTableViewCell.h"

#import "Venue.h"

@implementation VenueTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (BOOL)shouldUpdateCellWithObject:(Venue *)venue {
    self.textLabel.text = venue.name;
    return YES;
}

@end
