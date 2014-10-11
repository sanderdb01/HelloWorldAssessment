//
//  HWHomeTableViewCell.h
//  HelloWorldAssesment
//
//  Created by David Sanders on 10/10/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
