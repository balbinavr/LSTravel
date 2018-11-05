//
//  ShowActivityController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 30/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "ShowActivityController.h"

@implementation ShowActivityController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _titleTextField.text = _activity.activityName;
    _dateTextField.text = _activity.date;
    _descriptionTextField.text = _activity.activityDesc;
    _phoneTextField.text = _activity.activityPhone;
    _emailTextField.text = _activity.activityEmail;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phonePressed:)];
    // if labelView is not set userInteractionEnabled, you must do so
    [_phoneTextField setUserInteractionEnabled:YES];
    [_phoneTextField addGestureRecognizer:gesture];
    
    UITapGestureRecognizer* gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailPressed:)];
    [_emailTextField setUserInteractionEnabled:YES];
    [_emailTextField addGestureRecognizer:gesture1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_activity.activityId forKey:@"Activity"];
    [defaults synchronize];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _activity.location;
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

- (void)phonePressed:(UIGestureRecognizer*)gestureRecognizer{
    NSString *URLString = [@"tel://" stringByAppendingString:_phoneTextField.text];
    NSURL *URL = [NSURL URLWithString:URLString];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)emailPressed:(UIGestureRecognizer*)gestureRecognizer{
    
    NSString *email = [@"mailto:" stringByAppendingString:_emailTextField.text];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Navigation

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
