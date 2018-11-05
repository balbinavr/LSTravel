//
//  Activity+CoreDataProperties.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 24/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Activity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Activity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *activityId;
@property (nullable, nonatomic, retain) NSString *activityName;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *activityDesc;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *activityEmail;
@property (nullable, nonatomic, retain) NSString *activityPhone;
@property (nullable, nonatomic, retain) Trip *trip;

@end

NS_ASSUME_NONNULL_END
