//
//  LoginViewController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 9/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(IBAction)buttonLoginPressed:(id)sender{
    //go to next view
    NSString * email = self.addressIDTextField.text;
    NSString * password = self.passwordTextField.text;
    if ([email isEqualToString:@""] || [password isEqualToString:@""]){
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Empty fields" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
    }else{
        [WebServiceManager logInApiCallUser:email andPassword:password withCompletionHandler:^(WebResponse *data) {
            // Make sure that there is data.
            if (data != nil) {
                NSLog(@"LOGIN Data = %@",data.res);
                NSLog(@"LOGIN Data = %@",data.msg);
                
                if ([data.res isEqual:@1]){
                    // Store the data
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:email forKey:@"User"];
                    [defaults setObject:password forKey:@"Password"];
                    [defaults synchronize];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [self performSegueWithIdentifier:@"login" sender:self];
                }else{
                    
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
            }
        }];
        
    }
}

-(IBAction)buttonRegisterPressed:(id)sender{
    //go to next view
    [self performSegueWithIdentifier:@"register" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
