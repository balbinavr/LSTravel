//
//  WebServiceManager.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 22/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "WebServiceManager.h"

#define URL_LSTRAVEL @"http://so.housing.salle.url.edu/ms/lstravel.php"

#define URL_SIGNUP @"method=signup&usr=USER&mai=MAIL&pwd=PASSWD"
#define URL_LOGIN @"method=login&mai=MAIL&pwd=PASSWD"
#define URL_RECOVERY @"method=recovery&mai=MAIL"
#define URL_GET_INFO @"method=get-info&mai=MAIL&pwd=PASSWD"
#define URL_GET_ALL_USERS @"method=get-all-users"
#define URL_CREATE_TRIP @"method=create-trip&mai=MAIL&pwd=PASSWD&nom=NAME&pla=DESTINATION&arr=ARRIVAL&dep=DEPARTURE"
#define URL_UPDATE_TRIP @"method=update-trip&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&name=NAME&pla=DESTINATION&arr=ARRIVAL&dep=DEPARTURE"
#define URL_REMOVE_TRIP @"method=remove-trip&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID"
#define URL_SHARE @"method=share&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&userID=USER_ID"
#define URL_ADD_ACTIVITY @"method=add-activity&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&name=NAME&date=DATE&desc=DESCRIPTION&loca=LOCATION&mail=ORG_&phon=PHONE"
#define URL_UPDATE_ACTIVITY @"method=update-activity&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&activityID=ACTIVITY_ID&name=NAME&date=DATE&desc=DESCRIPTION&loca=LOCATION&mail=MAILORG&phon=PHONEORG"
#define URL_REMOVE_ACTIVITY @"method=remove-activity&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&activityID=ACTIVITY_ID"
#define URL_REMOVE_IMAGE @"method=remove-image&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&imageID=IMG_ID"
#define URL_ADD_IMAGE @"method=add-image&mai=MAIL&pwd=PASSWD&tripID=TRIP_ID&name=NAME_IMG&img=IMAGE64"

@implementation WebServiceManager

+(void) signUpApiCall: (User*)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_SIGNUP;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"USER" withString:user.userName];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:user.email];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:user.password];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil){
                                                               
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                           
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                completionHandler(response);
                                                               }];
                                                           
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                               completionHandler(nil);
                                                               }];
                                                           }
                                                       }];
    [dataTask resume];
    
}


+(void) logInApiCallUser:(NSString*)user andPassword: (NSString*) passwd withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_LOGIN;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:user];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:passwd];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) recoveryPasswordApiCall: (NSString *) email{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_RECOVERY;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:email];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"RECOVER Data = %@",text);
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}


+(void) getUserInfoApiCall: (User*)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_GET_INFO;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:user.email];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:user.password];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSArray *info = [responseDictionary valueForKeyPath:@"info"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               response.info = info;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) getAllUsersApiCallwithCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params = URL_GET_ALL_USERS;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSArray *info = [responseDictionary valueForKeyPath:@"info"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               response.info = info;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) createTripApiCall:(Trip*)trip withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_CREATE_TRIP;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:[trip.owner valueForKey:@"email"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:[trip.owner valueForKey:@"password"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"NAME" withString:trip.tripName];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DESTINATION" withString:trip.location];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"ARRIVAL" withString:trip.arrival];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DEPARTURE" withString:trip.departure];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) updateTripApiCall: (Trip*)trip withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_UPDATE_TRIP;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:[trip.owner valueForKey:@"email"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:[trip.owner valueForKey:@"password"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@",trip.tripId]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"NAME" withString:trip.tripName];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DESTINATION" withString:trip.location];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"ARRIVAL" withString:trip.arrival];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DEPARTURE" withString:trip.departure];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) removeTripApiCall: (Trip*) trip withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_REMOVE_TRIP;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:[trip.owner valueForKey:@"email"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:[trip.owner valueForKey:@"password"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@",trip.tripId]];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    
    [dataTask resume];
    
}

+(void) shareTripApiCall: (Trip *)trip to: (User *)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_SHARE;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:[trip.owner valueForKey:@"email"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:[trip.owner valueForKey:@"password"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@",trip.tripId]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"USER_ID" withString:[NSString stringWithFormat:@"%@",user.userId ]];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"SHARE-TRIP Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) addActivityTripApiCall: (Activity*)activity on:(User *)user withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_ADD_ACTIVITY;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:user.email];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:user.password];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@", activity.trip.tripId]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"NAME" withString:activity.activityName];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DATE" withString:activity.date];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DESCRIPTION" withString:activity.activityDesc];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"LOCATION" withString:activity.location];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"ORG_" withString:activity.activityEmail];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PHONE" withString:activity.activityPhone];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

+(void) updateActivityTripApiCall: (Activity*) activity{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_UPDATE_ACTIVITY;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:[[activity.trip valueForKey:@"owner"] valueForKey:@"email"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:[[activity.trip valueForKey:@"owner"] valueForKey:@"password"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@", [activity.trip valueForKey:@"tripId"]]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"ACTIVITY_ID" withString:[NSString stringWithFormat:@"%@",activity.activityId]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"NAME" withString:activity.activityName];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DATE" withString:activity.date];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"DESCRIPTION" withString:activity.activityDesc];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"LOCATION" withString:activity.location];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"ORG" withString:activity.activityEmail];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PHONE" withString:activity.activityPhone];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}



+(void) removeActivityApiCall: (Activity*) activity withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_REMOVE_ACTIVITY;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:[[activity.trip valueForKey:@"owner"] valueForKey:@"email"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:[[activity.trip valueForKey:@"owner"] valueForKey:@"password"]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@", [activity.trip valueForKey:@"tripId"]]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"ACTIVITY_ID" withString:[NSString stringWithFormat:@"%@",activity.activityId]];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}



+(void) addImageApiCall:(User *)user for:(NSString*)tripID and:(NSString*)img64 withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_ADD_IMAGE;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:user.email];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:user.password];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:[NSString stringWithFormat:@"%@", tripID]];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"IMAGE64" withString:[NSString stringWithFormat:@"%@",img64]];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];

    [dataTask resume];
    
}

+(void) removeImageApiCall:(User *)user for:(NSString*)tripID and:(NSString*)imgid withCompletionHandler:(void(^)(WebResponse *data))completionHandler{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:URL_LSTRAVEL];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * defineParams = URL_REMOVE_IMAGE;
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"MAIL" withString:user.email];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"PASSWD" withString:user.password];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"TRIP_ID" withString:tripID];
    defineParams = [defineParams stringByReplacingOccurrencesOfString:@"IMG_ID" withString:imgid];
    NSLog(@"FinalParams = %@",defineParams);
    NSString * params = defineParams;
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil){
                                                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                               NSString *res = [responseDictionary valueForKeyPath:@"res"];
                                                               NSString *msg = [responseDictionary valueForKeyPath:@"msg"];
                                                               NSLog(@"Res = %@",res);
                                                               NSLog(@"Msg = %@",msg);
                                                               WebResponse * response = [[WebResponse alloc] init];
                                                               response.res = res;
                                                               response.msg = msg;
                                                               
                                                               // Call the completion handler with the returned data on the main thread.
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(response);
                                                               }];
                                                               
                                                           }else{
                                                               //Error en la connexio
                                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                   completionHandler(nil);
                                                               }];
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}


@end
