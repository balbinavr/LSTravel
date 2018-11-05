//
//  CreateTripController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "CreateTripController.h"

@implementation CreateTripController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(IBAction)buttonSavePressed:(id)sender{
    //go to next view
    NSString * title = self.titleTextField.text;
    NSString * location = self.locationTextField.text;
    NSString * arrival = self.arrivalTextField.text;
    NSString * departure = self.departureTextField.text;
    
    if ([title isEqualToString:@""] || [location isEqualToString:@""] || [arrival isEqualToString:@""] || [departure isEqualToString:@""]){
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Empty fields" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
    }else{
        
        /*NSError *error = NULL;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:arrival
                                                            options:0
                                                              range:NSMakeRange(0, [arrival length])];
        NSUInteger numberOfMatchesDep = [regex numberOfMatchesInString:departure
                                                            options:0
                                                              range:NSMakeRange(0, [departure length])];
        if (numberOfMatches != 1 || numberOfMatchesDep != 1){
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Date Format Invalid" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
        }else{*/
            Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
            trip.tripName = title;
            trip.location = location;
            trip.arrival = arrival;
            trip.departure = departure;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            user.email = [defaults objectForKey:@"User"];
            user.password = [defaults objectForKey:@"Password"];
            trip.owner = user;
        
                NSLog(@"TRIP Data = %@ %@ %@ %@",trip.tripName, trip.location, trip.arrival, trip.departure);
                [WebServiceManager createTripApiCall:trip withCompletionHandler:^(WebResponse *data) {
                    // Make sure that there is data.
                    if (data != nil) {
                        NSLog(@"LOGIN Data = %@",data.res);
                        NSLog(@"LOGIN Data = %@",data.msg);
                        
                        if ([data.res isEqual:@1]){
                            
                            [self performSegueWithIdentifier:@"saved" sender:self];
                        }else{
                            
                            [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
                        }
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
                    }
                }];
        //}
        
    }

}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
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
