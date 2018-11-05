//
//  RegisterViewController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 11/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "WebResponse.h"

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

-(IBAction)buttonRegisterPressed:(id)sender;

@end
