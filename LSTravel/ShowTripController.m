//
//  ShowTripController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "ShowTripController.h"

@implementation ShowTripController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _titleTextField.text = _trip.tripName;
    _arrivalTextField.text = _trip.arrival;
    _departureTextField.text = _trip.departure;
    
    _titleTextField.userInteractionEnabled = NO;
    _arrivalTextField.userInteractionEnabled = NO;
    _departureTextField.userInteractionEnabled = NO;
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([_trip.owner.userId isEqual:[defaults objectForKey:@"UserId"]] && _trip.subscriptors == nil){
        
    }else if ([_trip.owner.userId isEqual:[defaults objectForKey:@"UserId"]]){
        
    }else{
        _shareButton.hidden = YES;
        _exploreButton.hidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
    _saveButton.hidden = YES;
    [defaults setObject:_trip.tripId forKey:@"Trip"];
    [defaults synchronize];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _trip.location;
    request.region = _mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                NSLog(@"name = %@", item.name);
                NSLog(@"Phone = %@", item.phoneNumber);
                //[item openInMapsWithLaunchOptions:nil];
                MKPlacemark *temp = item.placemark;
                CLLocationCoordinate2D coords = temp.location.coordinate;
                MKCoordinateRegion region;
                region.center.latitude = coords.latitude;
                region.center.longitude = coords.longitude;
                region.span.latitudeDelta = 0.201;
                region.span.longitudeDelta = 0.201;
                [self.mapView setRegion:region animated:YES];
                
            }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(IBAction)buttonSavePressed:(id)sender{
    
    _trip.tripName = _titleTextField.text;
    _trip.arrival = _arrivalTextField.text;
    _trip.departure = _departureTextField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    _trip.owner = user;
    
    NSLog(@"TRIP Data = %@ %@ %@ %@",_trip.tripName, _trip.location, _trip.arrival, _trip.departure);
    [WebServiceManager updateTripApiCall:_trip withCompletionHandler:^(WebResponse *data) {
        // Make sure that there is data.
        if (data != nil) {
            NSLog(@"LOGIN Data = %@",data.res);
            NSLog(@"LOGIN Data = %@",data.msg);
            
            if ([data.res isEqual:@1]){
                
                [self performSegueWithIdentifier:@"updated" sender:self];
                
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];

    
    [self performSegueWithIdentifier:@"updated" sender:self];
    
}

-(IBAction)buttonExplorePressed:(id)sender{
    
        UITabBarController *tabBar = [[UITabBarController alloc] init];
        
        ActivitiesListController *activitiesController = [self.storyboard instantiateViewControllerWithIdentifier:@"Activities"];
        
        ImagesListController *imagesController = [self.storyboard instantiateViewControllerWithIdentifier:@"Images"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        if ([_trip.owner.userId isEqual:[defaults objectForKey:@"UserId"]]){
            TakePictureController *takePicture = [self.storyboard instantiateViewControllerWithIdentifier:@"Picture"];
            NSArray *controllers = [NSArray arrayWithObjects:activitiesController,imagesController,takePicture,nil];
            activitiesController.mio=TRUE;
            tabBar.viewControllers = controllers;
            [[tabBar.tabBar.items objectAtIndex:0] setTitle:@"Activities"];
            [[tabBar.tabBar.items objectAtIndex:1] setTitle:@"Images"];
            [[tabBar.tabBar.items objectAtIndex:2] setTitle:@"Take Picture"];
        }else{
            NSArray *controllers = [NSArray arrayWithObjects:activitiesController,imagesController,nil];
            activitiesController.mio=FALSE;
            tabBar.viewControllers = controllers;
            [[tabBar.tabBar.items objectAtIndex:0] setTitle:@"Activities"];
            [[tabBar.tabBar.items objectAtIndex:1] setTitle:@"Images"];
            
        }
        
        [self.navigationController pushViewController:tabBar animated:YES];
        
}

-(IBAction)buttonSharePressed:(id)sender{
    [self performSegueWithIdentifier:@"share" sender:self];
}

-(IBAction)buttonEditPressed:(id)sender{
    _titleTextField.userInteractionEnabled = YES;
    _arrivalTextField.userInteractionEnabled = YES;
    _departureTextField.userInteractionEnabled = YES;
    _saveButton.hidden = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"share"]) {
        ShareTripController *destViewController = segue.destinationViewController;
        destViewController.trip = _trip;
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
