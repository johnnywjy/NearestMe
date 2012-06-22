//
//  MyLocListTableViewController.m
//  NearestMe
//
//  Created by lynny on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyLocListTableViewController.h"
#import "MyLocationEntity.h"

@implementation MyLocListTableViewController

@synthesize managedObjectContext;
@synthesize myLocationEntityArray;

// ================================================================================================
#pragma mark - Delegate Methods

- (void) newLocationEntryComplete:(NewLocationEntryViewController *)controller wasCancelled:(BOOL)cancelled {
    
    NSLog(@"The %@ button was pressed", (cancelled==NO?@"Done":@"Cancle"));
    if (cancelled == NO) {
        CLLocation *location = [controller location];
        NSString *nameStr = [controller nameStr];
        NSString *commentStr = [controller commentStr];
        NSNumber *proximity = [NSNumber numberWithDouble:0.0];
        
        // ==========================================================
        // Create and configure a new instance of the Location entity
        MyLocationEntity *newLocationEntity = (MyLocationEntity *)[NSEntityDescription
                                                                   insertNewObjectForEntityForName:@"MyLocationEntity"
                                                                   inManagedObjectContext:managedObjectContext];
        [newLocationEntity setName:nameStr];
        [newLocationEntity setComment:commentStr];
        [newLocationEntity setLatitude:[NSNumber numberWithDouble:[location coordinate].latitude]];
        [newLocationEntity setLongitude:[NSNumber numberWithDouble:[location coordinate].longitude]];
        [newLocationEntity setProximity:proximity];
        
        // ==========================================================
        // Save the new event
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // We should handle the error
            NSLog(@"Error in saving an event in addLocation");
        }
        
        // ==========================================================
        // Update our location array and the table view
        [myLocationEntityArray insertObject:newLocationEntity atIndex:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                withRowAnimation:UITableViewRowAnimationFade];
        [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
    [self dismissModalViewControllerAnimated:YES];
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

// ================================================================================================
#pragma mark - Core Location Delegate Methods

- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {
    
    [addButton setEnabled:YES];
    [self updateProximityWithNewLocation:newLocation];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [addButton setEnabled:NO];
}

// ================================================================================================


// ================================================================================================
#pragma mark - Core Data Methods

- (void) getDataFromCoreData {
    NSLog (@"Fetching data from Core in List View");
    // A bespoke method to retrieve the data, and store it in myLocationEntityArray
    // ====================================================================
    // Get data from Core Data - 1) Define the Fetch Request
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyLocationEntity"
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    // ====================================================================
    // Get data from Core Data - 2) Set the Sort Descriptor
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proximity" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    
    // ====================================================================
    // Get data from Core Data - 3) Execute the Request
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Need to handle the error
        NSLog(@"Error when fetching data from Core Data");
    }
    
    // ====================================================================
    // Cleaning up...
    
    [self setMyLocationEntityArray:mutableFetchResults];
    
    [mutableFetchResults release];
    [request release];
}

- (void) updateProximityWithNewLocation:(CLLocation *)newLocation {
    
    // Assumes that data has already been loaded into myLocationEntityArray
    if (myLocationEntityArray == nil) {
        return;
    }
    
    // Iterate through, to update proximity and find nearest object.
    
    MyLocationEntity *myloc;
    
    CLLocationDistance proximity;
    for (myloc in myLocationEntityArray) {
        CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[[myloc latitude] doubleValue]
                                                      longitude:[[myloc longitude] doubleValue]] autorelease];
        
        proximity = [loc distanceFromLocation:newLocation];
        [myloc setProximity:[NSNumber numberWithDouble:proximity]];
    }
    NSError *error = nil;
    [managedObjectContext save:&error];
}

- (void) addLocation{
    NewLocationEntryViewController *myVC = [[[NewLocationEntryViewController alloc]
                                             initWithNibName:@"NewLocationEntryViewController" bundle:nil] autorelease];
    [myVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [myVC setDelegate:self];
    
    
    // ==========================================================
    // Get current location
    CLLocation *location = [locationManager location];
    if (location == nil) {
        return;
    }

    [myVC setLocation:location]; 
    
    [self presentModalViewController:myVC animated:YES];    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Locations" image:[UIImage imageNamed:@"74-location.png"] tag:1]];
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
    [self setTitle:@"NearestMe"];
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocation)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton setEnabled:NO];
    
    //init for testing
    myLocationEntityArray = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSLog(@"MyLocListTableViewController about to appear");
    [[self locationManager] startUpdatingLocation];
    [self getDataFromCoreData];
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"MyLocListTableViewController about to disappear");
    [[self locationManager] stopUpdatingLocation];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myLocationEntityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MyLocationEntity *myloc = (MyLocationEntity *)[myLocationEntityArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[myloc name]];

    NSString *locStr = [NSString stringWithFormat:@"%.3f, %.3f",
                        [[myloc latitude] doubleValue],
                        [[myloc longitude] doubleValue]];
    [[cell detailTextLabel] setText:locStr];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
