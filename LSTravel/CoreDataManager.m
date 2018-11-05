//
//  CoreDataManager.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 28/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+ (NSArray *)testReadingCoreData:(NSManagedObjectContext *)context type:(NSString*) type{
    NSError *error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:type inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:&error];
    
}

+ (void)testRemovingCoreData:(NSManagedObjectContext *)context type:(NSString*) type{
    NSError *error = nil;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:type inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray* objectsReturned = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject* item in objectsReturned){
        [context deleteObject:item];
    }
    if (![context save:&error])
    {
        NSLog(@"Error deleting movie, %@", [error userInfo]);
    }
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
