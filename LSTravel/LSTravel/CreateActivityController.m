//
//  CreateActivityController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 30/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "CreateActivityController.h"

@implementation CreateActivityController

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
    NSString * date = self.dateTextField.text;
    NSString * phone = self.phoneTextField.text;
    NSString * email = self.mailTextField.text;
    NSString * description = self.descriptionTextField.text;
    
    if ([title isEqualToString:@""] || [location isEqualToString:@""] || [date isEqualToString:@""] || [phone isEqualToString:@""] || [email isEqualToString:@""] || [description isEqualToString:@""]){
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Empty fields" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
    }else{
        
        Activity* activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
        activity.activityName = title;
        activity.location = location;
        activity.date = date;
        activity.activityPhone = phone;
        activity.activityEmail = email;
        activity.activityDesc = description;
        
        Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.email = [defaults objectForKey:@"User"];
        user.password = [defaults objectForKey:@"Password"];
        trip.tripId = [defaults objectForKey:@"Trip"];
        activity.trip = trip;
        

        [WebServiceManager addActivityTripApiCall:activity on:user withCompletionHandler:^(WebResponse *data) {
            // Make sure that there is data.
            if (data != nil) {
                NSLog(@"LOGIN Data = %@",data.res);
                NSLog(@"LOGIN Data = %@",data.msg);
                
                if ([data.res isEqual:@1]){
                    [self.navigationController popViewControllerAnimated:YES];
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
