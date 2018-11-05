//
//  ActivitiesListController.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "WebResponse.h"
#import "CoreDataManager.h"
#import "CellActivityTableViewCell.h"
#import "CreateActivityController.h"
#import "ShowActivityController.h"

@interface ActivitiesListController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSArray<Activity*> *activities;
@property (readwrite) BOOL mio;
@property (weak, nonatomic) IBOutlet UITableView *taulaActivitats;

-(void)downloadData:(User*) user in:(NSString*)trip;
-(IBAction)buttonNewPressed:(id)sender;

@end
