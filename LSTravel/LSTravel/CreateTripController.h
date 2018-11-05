//
//  CreateTripController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "WebServiceManager.h"
#import "WebResponse.h"

@interface CreateTripController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *arrivalTextField;
@property (weak, nonatomic) IBOutlet UITextField *departureTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


-(IBAction)buttonSavePressed:(id)sender;

@end
