//
//  RegisterViewController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 11/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonRegisterPressed:(id)sender{
    //go to next view
    NSString * username = self.userNameTextField.text;
    NSString * email = self.addressIDTextField.text;
    NSString * password = self.passwordTextField.text;

    if ([email isEqualToString:@""] || [password isEqualToString:@""] || [username isEqualToString:@""]){
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Empty fields" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
        
    }else{
        
        NSError *error = NULL;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,6}"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:email
                                                            options:0
                                                              range:NSMakeRange(0, [email length])];
        if (numberOfMatches != 1){
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Email Format Invalid" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
        }else{
            if ([password length] < 8 || [self isPasswordValid:password] == FALSE){
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Password" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }else{
                User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                user.userName = username;
                user.email = email;
                user.password = password;
                [WebServiceManager signUpApiCall:user withCompletionHandler:^(WebResponse *data) {
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
                            [self performSegueWithIdentifier:@"register" sender:self];
                        }else{
                    
                            [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
                        }
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
                    }
                }];
            }
        }
        
    }
}

-(BOOL) isPasswordValid:(NSString *)pwd {
    if ( [pwd length]<6 || [pwd length]>32 ) return NO;  // too long or too short
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length ) return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )  return NO;  // no number;
    return YES;
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
