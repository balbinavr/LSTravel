//
//  Trip+CoreDataProperties.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 24/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Trip+CoreDataProperties.h"

@implementation Trip (CoreDataProperties)

@dynamic tripId;
@dynamic tripName;
@dynamic location;
@dynamic arrival;
@dynamic departure;
@dynamic images;
@dynamic activities;
@dynamic owner;
@dynamic subscriptors;

@end
