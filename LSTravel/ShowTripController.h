//
//  ShowTripController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Trip.h"
#import "User.h"
#import "WebServiceManager.h"
#import "WebResponse.h"
#import "ShareTripController.h"
#import "ActivitiesListController.h"
#import "TakePictureController.h"
#import "ImagesListController.h"


@interface ShowTripController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalTextField;
@property (weak, nonatomic) IBOutlet UITextField *departureTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) Trip* trip;

-(IBAction)buttonEditPressed:(id)sender;
-(IBAction)buttonSavePressed:(id)sender;
-(IBAction)buttonExplorePressed:(id)sender;
-(IBAction)buttonSharePressed:(id)sender;

@end
