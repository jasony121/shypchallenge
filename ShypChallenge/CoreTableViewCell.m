//
//  CoreTableViewCell.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "CoreTableViewCell.h"

#import "Venue.h"

@implementation CoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)shouldUpdateCellWithObject:(Venue *)venue {
    NSMutableString *s = [NSMutableString stringWithString:venue.name];
    [s appendString:[NSString stringWithFormat:@"\n%@, %@", venue.location.city, venue.location.state]];
    
    [venue.categories enumerateObjectsUsingBlock:^(VenueCategory *category, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [s appendString:@"\n"];
        } else {
            [s appendString:@", "];
        }
        
        [s appendString:category.name];
        
        *stop = (idx == 2);
    }];
    
    self.detailLabel.text = s;
    return YES;
}

@end
