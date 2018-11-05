//
//  MainListViewController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 11/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "MainListViewController.h"

@interface MainListViewController ()

@end

@implementation MainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    _taulaViatges.dataSource = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.taulaViatges;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    tableViewController.refreshControl = refresh;

    [self downloadData:user];
}

- (void) viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    [self downloadData:user];
}

-(void) handleRefresh:(UIRefreshControl *) refreshControl{
    NSLog(@"DINSS");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    [self downloadData:user];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.trips.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Trip* trip = [self.trips objectAtIndex:indexPath.row];
    cell.titleLabel.text = trip.tripName;
    cell.locationLabel.text = trip.location;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    NSLog(@"SUBSCRIPTOR COUNT %lu", trip.subscriptors.count);
    self.found = FALSE;
    if ([trip.owner.userId isEqual:[defaults objectForKey:@"UserId"]]){
        [self checkSharedData:user in:trip on:cell.titleLabel];
        /*if (self.found == TRUE){
            cell.titleLabel.textColor = [UIColor blueColor];
        }
        if(self.found == FALSE){
            cell.titleLabel.textColor = [UIColor greenColor];
        }*/
    }else{
        cell.titleLabel.textColor = [UIColor purpleColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Trip* trip = [self.trips objectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.email = [defaults objectForKey:@"User"];
        user.password = [defaults objectForKey:@"Password"];
        trip.owner = user;
        
        NSLog(@"TRIP Data = %@ %@ %@ %@",trip.tripName, trip.location, trip.arrival, trip.departure);
        [WebServiceManager removeTripApiCall:trip withCompletionHandler:^(WebResponse *data) {
            // Make sure that there is data.
            if (data != nil) {
                NSLog(@"LOGIN Data = %@",data.res);
                NSLog(@"LOGIN Data = %@",data.msg);
                
                if ([data.res isEqual:@1]){
                    [self downloadData:user];
                }else{
                    
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
            }
        }];

    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"details" sender:self];
}

-(IBAction)buttonLogoutPressed:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"UserId"];
    [defaults removeObjectForKey:@"User"];
    [defaults removeObjectForKey:@"Password"];
    self.taulaViatges = nil;
    [self.taulaViatges reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"logout" sender:self];
    
}

-(void)downloadData:(User*) user{
    [WebServiceManager getUserInfoApiCall:user withCompletionHandler:^(WebResponse *data) {
        // Make sure that there is data.
        if (data != nil) {
            NSLog(@"USER-INFO Data = %@",data.res);
            NSLog(@"USER-INFO Data = %@",data.msg);
            
            if ([data.res isEqual:@1]){
                // Store the data
                [CoreDataManager testRemovingCoreData:self.managedObjectContext type:@"Trip"];
                user.userId = [data.info valueForKeyPath:@"id"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:user.userId forKey:@"UserId"];
                user.userName = [data.info valueForKeyPath:@"nom"];
                NSArray* trips = [data.info valueForKeyPath:@"trips"];
                for(NSDictionary *item in trips) {
                    Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
                    trip.tripId = [item valueForKeyPath:@"id"];
                    trip.tripName = [item valueForKeyPath:@"nom"];
                    trip.location = [item valueForKeyPath:@"loc"];
                    trip.arrival = [item valueForKeyPath:@"arr"];
                    trip.departure = [item valueForKeyPath:@"dep"];
                    User* userOwn = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                    userOwn.userId = [item valueForKeyPath:@"own"];
                    trip.owner = userOwn;
                    NSArray* activities = [item valueForKeyPath:@"act"];
                    NSArray* activitiesArray = [[NSArray alloc ]init];
                    for(NSDictionary *itemAct in activities) {
                        Activity* activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:self.managedObjectContext];
                        activity.activityId = [itemAct valueForKeyPath:@"id"];
                        activity.activityName = [itemAct valueForKeyPath:@"nom"];
                        activity.date = [itemAct valueForKeyPath:@"dat"];
                        activity.activityDesc = [itemAct valueForKeyPath:@"des"];
                        activity.location = [itemAct valueForKeyPath:@"loc"];
                        activity.activityEmail = [itemAct valueForKeyPath:@"mai"];
                        activity.activityPhone = [itemAct valueForKeyPath:@"pho"];
                        activitiesArray = [activitiesArray arrayByAddingObject:activity];
                        
                    }
                    NSSet *activitiesSet = [[NSSet alloc] init];
                    [activitiesSet setByAddingObjectsFromArray:activitiesArray];
                    trip.activities = activitiesSet;
                    NSArray* images = [item valueForKeyPath:@"img"];
                    NSArray* imagesArray = [[NSArray alloc ]init];
                    for(NSDictionary *itemImg in images) {
                        Image* image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
                        image.imageId = [itemImg valueForKeyPath:@"id"];
                        image.imageName = [itemImg valueForKeyPath:@"nom"];
                        image.imagePath = [itemImg valueForKeyPath:@"path"];
                        imagesArray = [imagesArray arrayByAddingObject:image];
                        
                    }
                    NSSet *imagesSet = [[NSSet alloc] init];
                    [imagesSet setByAddingObjectsFromArray:imagesArray];
                    trip.images = imagesSet;
                    NSArray* subscriptors = [item valueForKeyPath:@"sha"];
                    NSArray* subsArray = [[NSArray alloc ]init];
                    for(NSDictionary *itemSubs in subscriptors) {
                        User* userSub = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                        userSub.userId = [itemSubs valueForKeyPath:@"subscriber"];
                        NSLog(@"SUBSCRIPTOR %@", userSub.userId);
                        subsArray = [subsArray arrayByAddingObject:userSub];
                        
                    }
                    NSSet *subsSet = [[NSSet alloc] init];
                    [subsSet setByAddingObjectsFromArray:subsArray];
                    trip.subscriptors = subsSet;
                    NSError *mocSaveError = nil;
                    if (![self.managedObjectContext save:&mocSaveError])
                    {
                        NSLog(@"Save did not complete successfully. Error: %@",
                              [mocSaveError localizedDescription]);
                    }else{
                        NSLog(@"Saved fine!");
                    }
                    
                }
                NSArray* tripsReturned = [CoreDataManager testReadingCoreData:self.managedObjectContext type:@"Trip"];
                for (Trip *info in tripsReturned){
                    NSLog(@"Trip: %@", info.tripId);
                }
                self.trips = tripsReturned;
                NSLog(@"COUNT RET: %lu", tripsReturned.count);
                NSLog(@"COUNT COP: %lu", self.trips.count);
                [self.taulaViatges reloadData];
                
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];

}

-(void)checkSharedData:(User*) user in:(Trip*)tripSearch on:(UILabel *)titleLabel{
    [WebServiceManager getUserInfoApiCall:user withCompletionHandler:^(WebResponse *data) {
        // Make sure that there is data.
        if (data != nil) {
            NSLog(@"USER-INFOCHECK Data = %@",data.res);
            NSLog(@"USER-INFOCHECK Data = %@",data.msg);
            
            if ([data.res isEqual:@1]){
                // Store the data
                NSArray* trips = [data.info valueForKeyPath:@"trips"];
                for(NSDictionary *item in trips) {
                    Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
                    trip.tripId = [item valueForKeyPath:@"id"];
                    if ([trip.tripId isEqual:tripSearch.tripId]){
                        
                        NSArray* subscriptors = [item valueForKeyPath:@"sha"];
                        NSArray* subsArray = [[NSArray alloc ]init];
                        for(NSDictionary *itemSubs in subscriptors) {
                            User* userSub = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                            userSub.userId = [itemSubs valueForKeyPath:@"subscriber"];
                            NSLog(@"SUBSCRIPTOR %@", userSub.userId);
                            subsArray = [subsArray arrayByAddingObject:userSub];
                        
                        }
                        if(subsArray.count > 0){
                            NSLog(@"TRUE");
                            titleLabel.textColor = [UIColor blueColor];
                        }else{
                            NSLog(@"FALSE");
                            titleLabel.textColor = [UIColor greenColor];
                        }
                     }
                }
                
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"details"]) {
        NSIndexPath *indexPath = [self.taulaViatges indexPathForSelectedRow];
        ShowTripController *destViewController = segue.destinationViewController;
        destViewController.trip = [_trips objectAtIndex:indexPath.row];
    }
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
