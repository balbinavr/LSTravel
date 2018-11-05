//
//  WebServiceManager.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 22/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Trip.h"
#import "User.h"
#import "Image.h"
#import "Activity.h"
#import "LoginViewController.h"
#import "WebResponse.h"

@interface WebServiceManager : NSObject

+(void) signUpApiCall: (User*)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) logInApiCallUser:(NSString*)user andPassword: (NSString*) passwd withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) recoveryPasswordApiCall: (NSString *)email;
+(void) getUserInfoApiCall: (User*)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) getAllUsersApiCallwithCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) createTripApiCall: (Trip*)trip withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) updateTripApiCall: (Trip*)trip withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) removeTripApiCall: (Trip*)trip withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) shareTripApiCall: (Trip *)trip to: (User *)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) addActivityTripApiCall: (Activity*)activity on:(User *)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) updateActivityTripApiCall: (Activity*) activity;
+(void) removeActivityApiCall: (Activity*) activity withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) addImageApiCall:(User *)user for:(NSString*)tripID and:(NSString*)img64 withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
+(void) removeImageApiCall:(User *)user for:(NSString*)tripID and:(NSString*)imgid withCompletionHandler:(void(^)(WebResponse *data))completionHandler;
;

@end
