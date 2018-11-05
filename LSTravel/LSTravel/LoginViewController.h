//
//  LoginViewController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 9/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "WebResponse.h"

@interface LoginViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

-(IBAction)buttonLoginPressed:(id)sender;
-(IBAction)buttonRegisterPressed:(id)sender;


@end
