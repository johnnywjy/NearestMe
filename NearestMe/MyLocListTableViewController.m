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
// ================================================================================================

- (void) addLocation{
    NewLocationEntryViewController *myVC = [[[NewLocationEntryViewController alloc]
                                             initWithNibName:@"NewLocationEntryViewController" bundle:nil] autorelease];
    [myVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [myVC setDelegate:self];
    
    // Create a fake location for testing purposes
    CLLocation *testLoc = [[[CLLocation alloc] initWithLatitude:37.330174 longitude:-122.032774] autorelease];
    [myVC setLocation:testLoc]; 
    
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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocation)];
    self.navigationItem.rightBarButtonItem = addButton;
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
