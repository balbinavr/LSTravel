//
//  MainListViewController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 11/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "WebResponse.h"
#import "CoreDataManager.h"
#import "CellTripTableViewCell.h"
#import "ShowTripController.h"

@interface MainListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSArray<Trip*> *trips;
@property (readwrite) BOOL found;

@property (weak, nonatomic) IBOutlet UITableView *taulaViatges;

-(IBAction)buttonLogoutPressed:(id)sender;

-(void)downloadData:(User*) user;

@end
