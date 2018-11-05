//
//  Trip+CoreDataProperties.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 24/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Trip.h"

NS_ASSUME_NONNULL_BEGIN

@interface Trip (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *tripId;
@property (nullable, nonatomic, retain) NSString *tripName;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *arrival;
@property (nullable, nonatomic, retain) NSString *departure;
@property (nullable, nonatomic, retain) NSSet<Image *> *images;
@property (nullable, nonatomic, retain) NSSet<Activity *> *activities;
@property (nullable, nonatomic, retain) User *owner;
@property (nullable, nonatomic, retain) NSSet<User *> *subscriptors;

@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet<Image *> *)values;
- (void)removeImages:(NSSet<Image *> *)values;

- (void)addActivitiesObject:(Activity *)value;
- (void)removeActivitiesObject:(Activity *)value;
- (void)addActivities:(NSSet<Activity *> *)values;
- (void)removeActivities:(NSSet<Activity *> *)values;

- (void)addSubscriptorsObject:(User *)value;
- (void)removeSubscriptorsObject:(User *)value;
- (void)addSubscriptors:(NSSet<User *> *)values;
- (void)removeSubscriptors:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
