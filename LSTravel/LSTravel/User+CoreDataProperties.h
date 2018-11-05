//
//  User+CoreDataProperties.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 24/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSSet<Trip *> *trips;
@property (nullable, nonatomic, retain) NSSet<Trip *> *subscriptorTrips;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTripsObject:(Trip *)value;
- (void)removeTripsObject:(Trip *)value;
- (void)addTrips:(NSSet<Trip *> *)values;
- (void)removeTrips:(NSSet<Trip *> *)values;

- (void)addSubscriptorTripsObject:(Trip *)value;
- (void)removeSubscriptorTripsObject:(Trip *)value;
- (void)addSubscriptorTrips:(NSSet<Trip *> *)values;
- (void)removeSubscriptorTrips:(NSSet<Trip *> *)values;

@end

NS_ASSUME_NONNULL_END
