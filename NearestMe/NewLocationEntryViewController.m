//
//  NewLocationEntryViewController.m
//  NearestMe
//
//  Created by CPD User on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLocationEntryViewController.h"

@implementation NewLocationEntryViewController

@synthesize location;
@synthesize latitudeLabel;
@synthesize longitudeLabel;
@synthesize mapView;
@synthesize nameTextField;
@synthesize commentTextField;
@synthesize navigationBar;
@synthesize delegate;

- (IBAction)done:(id)sender {
    [[self delegate] newLocationEntryComplete:self wasCancelled:NO];
}

- (IBAction)cancel:(id)sender {
    [[self delegate] newLocationEntryComplete:self wasCancelled:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [[[self navigationBar] topItem] setTitle:@"Add Location"];
    
    NSLog(@"NearestLocationViewController new location: latitude %+.6f, longitude %+.6f\n",
          [location coordinate].latitude,
          [location coordinate].longitude);
    
    [latitudeLabel setText:[NSString stringWithFormat:@"%.6f",[location coordinate].latitude]];
    [longitudeLabel setText:[NSString stringWithFormat:@"%.6f",[location coordinate].longitude]];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([location coordinate],
                                                                       0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    [mapView setRegion:adjustedRegion animated:YES];
    
}

- (void)viewDidUnload
{
    [self setLatitudeLabel:nil];
    [self setLongitudeLabel:nil];
    [self setMapView:nil];
    [self setNameTextField:nil];
    [self setCommentTextField:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [latitudeLabel release];
    [longitudeLabel release];
    [mapView release];
    [nameTextField release];
    [commentTextField release];
    [navigationBar release];
    [super dealloc];
}
@end
