//
//  NewLocationEntryViewController.h
//  NearestMe
//
//  Created by CPD User on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol NewLocationEntryViewControllerDelegate;

@interface NewLocationEntryViewController : UIViewController <UITextFieldDelegate>{
    id <NewLocationEntryViewControllerDelegate> delegate;
    CLLocation *location;
}

@property (retain, nonatomic) id <NewLocationEntryViewControllerDelegate> delegate;
@property (retain, nonatomic) CLLocation *location;
@property (retain, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *commentTextField;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol NewLocationEntryViewControllerDelegate
- (void) newLocationEntryComplete:(NewLocationEntryViewController *)controller wasCancelled:(BOOL)cancelled;
@end