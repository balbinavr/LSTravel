//
//  CreateActivityController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 30/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "WebServiceManager.h"
#import "WebResponse.h"

@interface CreateActivityController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

-(IBAction)buttonSavePressed:(id)sender;

@end
