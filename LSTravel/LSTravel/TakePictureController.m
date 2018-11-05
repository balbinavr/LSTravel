//
//  TakePictureController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "TakePictureController.h"

@implementation TakePictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)takePhoto:  (UIButton *)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)savePhoto:(UIButton *)sender{
    
    NSData * data = [UIImagePNGRepresentation(self.imageView.image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *encoder = [NSString stringWithUTF8String:[data bytes]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    NSString * tripid = [defaults objectForKey:@"Trip"];
    
    [WebServiceManager addImageApiCall:user for:tripid and:encoder withCompletionHandler:^(WebResponse *data) {
        // Make sure that there is data.
        if (data != nil) {
            NSLog(@"LOGIN Data = %@",data.res);
            NSLog(@"LOGIN Data = %@",data.msg);
            
            if ([data.res isEqual:@1]){
                
                //[self performSegueWithIdentifier:@"saved" sender:self];
                [[[UIAlertView alloc]initWithTitle:@"Success" message:data.msg delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];
    //}
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.image = chosenImage;
    self.imageView.image = chosenImage;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
