//
//  NearestLocationViewController.h
//  NearestMe
//
//  Created by lynny on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"

@interface NearestLocationViewController : UIViewController

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;


- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation;
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
