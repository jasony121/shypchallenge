//
//  ActionsTableViewCell.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *directionsButton;
@property (nonatomic, strong) IBOutlet UIButton *callButton;
@property (nonatomic, strong) IBOutlet UIButton *checkinButton;

@end
