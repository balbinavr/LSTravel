//
//  ShareTripController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "WebResponse.h"
#import "CoreDataManager.h"


@interface ShareTripController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSArray<User*> *usersSubs;
@property (strong,nonatomic) NSArray<User*> *userSub2;
@property (strong,nonatomic) Trip *trip;

@property (weak, nonatomic) IBOutlet UITableView *taulaUsers;


@end
