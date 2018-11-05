//
//  TakePictureController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "User.h"
#import "WebServiceManager.h"
#import "WebResponse.h"

@interface TakePictureController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property(strong, nonatomic) IBOutlet UIImage *image;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)savePhoto:(UIButton *)sender;

@end
