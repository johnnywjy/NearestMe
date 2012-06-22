//
//  MyLocListTableViewController.h
//  NearestMe
//
//  Created by lynny on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLocationEntryViewController.h"

@interface MyLocListTableViewController : UITableViewController <NewLocationEntryViewControllerDelegate>


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) addLocation;
- (void) newLocationEntryComplete:(NewLocationEntryViewController *)controller wasCancelled:(BOOL)cancelled;

@end
