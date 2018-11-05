//
//  ActivitiesListController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "ActivitiesListController.h"

@implementation ActivitiesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _taulaActivitats.dataSource = self;
    _taulaActivitats.delegate = self;
    [_taulaActivitats setAllowsSelection:YES];
    if (self.mio == TRUE){
    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(myRightButton)];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    trip.tripId = [defaults objectForKey:@"Trip"];
    NSLog(@"TRIPID = %@",[defaults objectForKey:@"Trip"]);
    [self downloadData:user in:[defaults objectForKey:@"Trip"]];
}

- (void) viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    trip.tripId = [defaults objectForKey:@"Trip"];
    NSLog(@"TRIPID = %@",[defaults objectForKey:@"Trip"]);
    [self downloadData:user in:[defaults objectForKey:@"Trip"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"Activities count ROW: %lu", (unsigned long)self.activities.count);
    return self.activities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellAct"];
    Activity* activity = [self.activities objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        NSLog(@"Cell was empty!");
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    cell.titleLabel.text = activity.activityName;
    cell.locationLabel.text = activity.location;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Activity* activity = [self.activities objectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.email = [defaults objectForKey:@"User"];
        user.password = [defaults objectForKey:@"Password"];
        Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
        trip.tripId = [defaults objectForKey:@"Trip"];
        NSLog(@"TRIPID = %@",[defaults objectForKey:@"Trip"]);
        trip.owner = user;
        [WebServiceManager removeActivityApiCall:activity withCompletionHandler:^(WebResponse *data) {
            // Make sure that there is data.
            if (data != nil) {
                NSLog(@"LOGIN Data = %@",data.res);
                NSLog(@"LOGIN Data = %@",data.msg);
                
                if ([data.res isEqual:@1]){
                    [self downloadData:user in:[defaults objectForKey:@"Trip"]];
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
    /*ShowActivityController *mvid=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowActivityController"];
    mvid.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    mvid.activity = [_activities objectAtIndex:indexPath.row];
    [self.navigationController presentModalViewController:mvid animated:YES];*/
    [self performSegueWithIdentifier:@"show" sender:self];
}

-(void)downloadData:(User*) user in:(NSString*)tripSearch{
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
                    NSLog(@"TRIP FOUND %@ - TRIP LOOKING %@", trip.tripId, tripSearch);
                    if ([trip.tripId isEqual:tripSearch]){
                        
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
                    self.activities = activitiesArray;
                    NSLog(@"Activities count COP: %lu", (unsigned long)self.activities.count);
                    NSLog(@"Activities count GET: %lu", (unsigned long)activitiesArray.count);
                    }
                }
                [self.taulaActivitats reloadData];
                
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];
    
}

-(void)myRightButton{
    [self performSegueWithIdentifier:@"create" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show"]) {
        NSIndexPath *indexPath = [self.taulaActivitats indexPathForSelectedRow];
        ShowActivityController *destViewController = segue.destinationViewController;
        destViewController.activity = [_activities objectAtIndex:indexPath.row];
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
