//
//  HWDetailsViewController.m
//  HelloWorldAssesment
//
//  Created by David Sanders on 10/10/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

#import "HWDetailsViewController.h"


@interface HWDetailsViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIColor *backgroundColor;
@property float red;
@property float green;
@property float blue;
@property int hwColor;

@end

@implementation HWDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.location.name;
    self.addressLabel.text = self.location.address;
    self.address2Label.text = self.location.address2;
    self.cityLabel.text = self.location.city;
    self.stateLabel.text = self.location.state;
    self.zipLabel.text = self.location.zipPostalCode;
    self.distanceLabel.text = [NSString stringWithFormat:@"Distance away: %.2fmiles", self.location.distanceFromUser];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    self.hwColor = 0;
    self.red = 0.0;
    self.green = 136.0;
    self.blue = 199.0;
    self.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];
    
    //pull data for imageview and convert to UIImage
    NSData *photoData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString: self.location.officeImage]];
    UIImage *officePhoto = [[UIImage alloc] initWithData:photoData];
    self.officeImageView.image = officePhoto;
    
    //set delegates
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    
    //have mapView zoom to office's location
    [self zoomToOfficeLocation];
    
    self.view.backgroundColor = self.backgroundColor;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)callLocationButtonPressed:(UIButton *)sender
{
    
    //NSString *phoneNumber = [NSString stringWithFormat:@"tel:2482123283"];
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"()- "];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [self.location.phone componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *phoneString = [arrayOfComponents componentsJoinedByString:@""];
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", phoneString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)takeMeThereButtonPressed:(UIButton *)sender
{
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.location.latitude floatValue], [self.location.longitude floatValue]);
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    MKMapItem *mapItemLocation = [[MKMapItem alloc] initWithPlacemark:place];
    MKMapItem *mapItemUser = [MKMapItem mapItemForCurrentLocation];
    NSArray *mapItems = @[mapItemLocation, mapItemUser];
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    [MKMapItem openMapsWithItems:mapItems launchOptions:options];
}

#pragma mark - MapView Helper Methods

-(void)zoomToOfficeLocation
{
    MKCoordinateRegion region;
    CLLocationDegrees longitude = [self.location.longitude doubleValue];
    CLLocationDegrees latitude = [self.location.latitude floatValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    region.center = coordinate;
    region.span = MKCoordinateSpanMake(0.05, 0.05);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    annotation.title = self.location.name;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - timer method

-(void)timerFired
{
    switch (self.hwColor)
    {
        case 0:
            if (self.red != 255.0)
                self.red++;
            if (self.green != 80.0)
                self.green--;
            if (self.blue != 14.0)
                self.blue--;
            if (self.red == 255.0 && self.green == 80.0 && self.blue == 14.0)
                self.hwColor = 1;
            break;
        case 1:
            if (self.red != 167.0)
                self.red--;
            if (self.green != 167.0)
                self.green++;
            if (self.blue != 167.0)
                self.blue++;
            if (self.red == 167.0 && self.green == 167.0 && self.blue == 167.0)
                self.hwColor = 2;
            break;
        case 2:
            if (self.red != 85.0)
                self.red--;
            if (self.green != 85.0)
                self.green--;
            if (self.blue != 85.0)
                self.blue--;
            if (self.red == 85.0 && self.green == 85.0 && self.blue == 85.0)
                self.hwColor = 3;
            break;
        case 3:
            if (self.red != 0.0)
                self.red--;
            if (self.green != 136.0)
                self.green++;
            if (self.blue != 199.0)
                self.blue++;
            if (self.red == 0.0 && self.green == 136.0 && self.blue == 199.0)
                self.hwColor = 0;
            break;
            
        default:
            break;
    }
    self.backgroundColor = [UIColor colorWithRed:self.red/255 green:self.green/255 blue:self.blue/255 alpha:1];
    self.view.backgroundColor = self.backgroundColor;

//    if (self.red == 0)
//    {
//        self.red = 255;
//        self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:123.0/255 blue:14.0/255 alpha:1];
//        //[self.view setBackgroundColor:[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1]];
//    }else
//    {
//        self.red = 0;
//    self.view.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];
//    }

}

@end
