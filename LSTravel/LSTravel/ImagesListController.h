//
//  ImagesListController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "User.h"
#import "Trip.h"
#import "WebServiceManager.h"
#import "WebResponse.h"
#import "CoreDataManager.h"

@interface ImagesListController : UICollectionViewController

@property (strong,nonatomic) NSArray<Image*> *images;

@property (weak, nonatomic) IBOutlet UICollectionView *taulaImages;

-(void)downloadData:(User*) user in:(NSString*)trip;

@end
