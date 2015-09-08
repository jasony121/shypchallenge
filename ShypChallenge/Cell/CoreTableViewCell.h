//
//  CoreTableViewCell.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NimbusModels.h"

@interface CoreTableViewCell : UITableViewCell <NICell>

@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

@end
