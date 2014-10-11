//
//  HWDetailsViewController.h
//  HelloWorldAssesment
//
//  Created by David Sanders on 10/10/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HWHomeViewController.h"
#import "HWConstants.h"
#import "HWLocation.h"
#import "HWHomeTableViewCell.h"


@interface HWDetailsViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *officeImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) HWLocation *location;

- (IBAction)callLocationButtonPressed:(UIButton *)sender;
- (IBAction)takeMeThereButtonPressed:(UIButton *)sender;

@end
