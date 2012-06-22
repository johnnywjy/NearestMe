//
//  NearestLocationViewController.m
//  NearestMe
//
//  Created by lynny on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearestLocationViewController.h"

@implementation NearestLocationViewController

@synthesize locationManager;
@synthesize managedObjectContext;


// ================================================================================================
#pragma mark - Core Location Delegate Methods

- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"NearestLocationViewController new location: latitude %+.6f, longitude %+.6f\n",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // For now, do nothing other than report to the log
    NSLog(@"Unable to get location events");
}

- (CLLocationManager *)locationManager
{
    if (locationManager != nil) {
        return locationManager;
    }
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager setDistanceFilter:10];
    [locationManager setDelegate:self];
    
    return locationManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Nearest" image:[UIImage imageNamed:@"103-map.png"] tag:0]];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"NearestLocationViewController about to appear");
    [[self locationManager] startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"NearestLocationViewController about to disappear");
    [[self locationManager] stopUpdatingLocation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
