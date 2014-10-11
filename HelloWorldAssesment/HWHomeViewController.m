//
//  HWHomeViewController.m
//  HelloWorldAssesment
//
//  Created by David Sanders on 10/9/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "HWHomeViewController.h"
#import "HWConstants.h"
#import "HWLocation.h"
#import "HWHomeTableViewCell.h"
#import "HWDetailsViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface HWHomeViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableDictionary *allLocationsDictionary;
@property (strong, nonatomic) NSMutableArray *allLocationsArray;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation HWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Lazy instantiation
    if (!self.allLocationsDictionary) {
        self.allLocationsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (!self.allLocationsArray) {
        self.allLocationsArray = [[NSMutableArray alloc]init];
    }
    
    //run the location data and distance data on a seperate thread
    //dispatch_queue_t mapQueue =  dispatch_queue_create("map queue", NULL);
    
    //dispatch_async(mapQueue, ^{
        
        //get the location data from the URL
        self.allLocationsDictionary = [[self dictionaryFromJsonLocations] mutableCopy];
        self.allLocationsArray = [self locationsArrayFromDictionary:self.allLocationsDictionary];
        
        //Set up the MapView
        self.mapView.delegate = self;
        
        //--Added for upgrade to iOS 8
        self.locationManager.delegate = self;
        self.locationManager = [[CLLocationManager alloc] init];
        if (IS_OS_8_OR_LATER) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        self.mapView.showsUserLocation = YES;
        self.mapView.showsPointsOfInterest = YES;
        [self placeMarkersOnMap];
        
        // Run Method that finds and assigns all the distances from the user into the HWLocation objects
        [self findDistancesOfLocations];
        
        // Sort allLocationsArray by distances
        [self arrangeLocationsByDistances];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        //Reload the TableView info
        [self.tableView reloadData];
        //});
    //});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(NSDictionary *)dictionaryFromJsonLocations
{
    //Method that reads the JSON data from a URL and returns a dictionary
    NSData *allLocationData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString: @"http://www.helloworld.com/helloworld_locations.json"]];
    NSError *locationError;
    NSMutableDictionary *allLocations = [NSJSONSerialization
                                         JSONObjectWithData:allLocationData
                                         options:NSJSONReadingMutableContainers
                                         error:&locationError];
    if (locationError)
    {
        NSLog(@"%@", locationError.localizedDescription);
        //
        // If there is an error getting the locations from the URL, the app uses the locally save locations as a back up
        //
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *plist = [bundle URLForResource:@"locations" withExtension:@"plist"];
        NSDictionary *locationDictionary = [NSDictionary dictionaryWithContentsOfURL:plist];
        return locationDictionary;
    }
    else
    {
        return allLocations;
    }
}

-(NSMutableArray *)locationsArrayFromDictionary:(NSDictionary *)locationsDictionary
{
    //Method that takes a dictionary parameter form the JSON download and returns an array of HWLocation objects
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    NSArray *locationsArray = [[NSArray alloc] initWithArray:locationsDictionary[@"locations"]];
    for (NSDictionary *locationDictionary in locationsArray) {
        HWLocation *location = [[HWLocation alloc] initWithDictionaryData:locationDictionary];
        [locations addObject:location];
    }
    
    return locations;
}

-(void)arrangeLocationsByDistances
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distanceFromUser" ascending:YES];
    NSArray *sortedArray = [self.allLocationsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.allLocationsArray = [sortedArray mutableCopy];
}

#pragma mark - Map Helper Methods

-(void)placeMarkersOnMap
{
    //Places markers for all of the HWLocations in the allLocationsArray property
    for (HWLocation *location in self.allLocationsArray)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationDegrees longitude = [location.longitude doubleValue];
        CLLocationDegrees latitude = [location.latitude floatValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        annotation.coordinate = coordinate;
        annotation.title = location.name;
        [self.mapView addAnnotation:annotation];
    }
    
}

-(void)findDistancesOfLocations
{
    //Takes the allLocationsArray and finds all the distances bases on the current location
    CLLocation *userLocation = [self.locationManager location];
    for (HWLocation *location in self.allLocationsArray) {
        CLLocationDegrees longitude = [location.longitude doubleValue];
        CLLocationDegrees latitude = [location.latitude floatValue];
        CLLocation *officeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        int distance = [userLocation distanceFromLocation:officeLocation];
        location.distanceFromUser = distance * 0.00062137;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToDetailSegue"]) {
        HWDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.location = sender;
    }
}

#pragma mark - UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allLocationsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    HWLocation *location = [[HWLocation alloc]init];
    location = self.allLocationsArray[indexPath.row];
    cell.nameLabel.text = location.name;
    cell.locationLabel.text = location.address;
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %.2fmiles", location.distanceFromUser];
    return cell;
}


#pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"homeToDetailSegue" sender:self.allLocationsArray[indexPath.row]];
}


@end
