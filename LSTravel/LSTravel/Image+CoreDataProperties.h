//
//  Image+CoreDataProperties.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 24/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *imageId;
@property (nullable, nonatomic, retain) NSString *imageName;
@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) Trip *trip;

@end

NS_ASSUME_NONNULL_END
