//
//  CoreDataManager.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 28/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceManager.h"
#import "WebResponse.h"

@interface CoreDataManager : NSObject

+ (NSArray *)testReadingCoreData:(NSManagedObjectContext *)context type:(NSString*) type;
+ (void)testRemovingCoreData:(NSManagedObjectContext *)context type:(NSString*) type;

@end
