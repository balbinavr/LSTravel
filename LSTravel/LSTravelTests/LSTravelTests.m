//
//  LSTravelTests.m
//  LSTravelTests
//
//  Created by Balbina Virgili Rocosa on 9/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebServiceManager.h"
#import "User.h"
#import "Trip.h"
#import "Activity.h"

@interface LSTravelTests : XCTestCase

@end

@implementation LSTravelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //[WebServiceManager logInApiCallUser:@"usuari1@gmail.com" andPassword:@"12345678"];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.userId = [NSNumber numberWithInt:212];
    user.userName = @"usuari1";
    user.email = @"usuari1@gmail.com";
    user.password = @"12345678";
    //[WebServiceManager signUpApiCall:user];
    //[WebServiceManager recoveryPasswordApiCall:user.email];
    //[WebServiceManager getUserInfoApiCall:user];
    [WebServiceManager getAllUsersApiCall];
    /*Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    trip.owner = user;
    trip.tripId = [NSNumber numberWithInt:537];
    trip.tripName = @"Best Experience";
    trip.location = @"Barcelona";
    trip.arrival = @"01/08/2016";
    trip.departure = @"08/08/2016";*/
    //[WebServiceManager createTripApiCall:trip];
    //trip.location = @"New York";
    //[WebServiceManager updateTripApiCall:trip];
    //[WebServiceManager removeTripApiCall:trip];
    
    //User* userShare = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    //userShare.userId = [NSNumber numberWithInt:207];
    //[WebServiceManager shareTripApiCall: trip to: userShare];
    
    /*Activity* activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
    activity.trip = trip;
    activity.activityName = @"Visit Park Guell";
    activity.date = @"02/08/2016";
    activity.activityDesc = @"Wonderful park";
    activity.location = @"Barcelona";
    activity.activityEmail = @"parkguell@gmail.com";
    activity.activityPhone = @"999999999";
    //[WebServiceManager addActivityTripApiCall:activity];
    activity.activityPhone = @"666666666";
    activity.activityId = [NSNumber numberWithInt:213];
    //[WebServiceManager updateActivityTripApiCall:activity];*/
    
    //[WebServiceManager removeActivityApiCall:activity];
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
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
