//
//  LocationEntityAnnotation.m
//  NearestMe
//
//  Created by CPD User on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationEntityAnnotation.h"

@implementation LocationEntityAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate title:(NSString *)newTitle subtitle:(NSString *)newSubtitle {
    
    if ((self = [super init])) {
        title = [newTitle copy];
        subtitle = [newSubtitle copy];
        coordinate = newCoordinate;
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end
