//
//  ShowActivityController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 30/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Activity.h"
#import "User.h"
#import "WebServiceManager.h"
#import "WebResponse.h"
#import "ShareTripController.h"

@interface ShowActivityController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) Activity* activity;

@end
