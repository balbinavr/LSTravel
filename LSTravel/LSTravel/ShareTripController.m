//
//  ShareTripController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "ShareTripController.h"

@implementation ShareTripController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    //_taulaUsers.dataSource = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    
    [WebServiceManager getAllUsersApiCallwithCompletionHandler:^(WebResponse *data) {
        // Make sure that there is data.
        if (data != nil) {
            NSLog(@"USER-INFO Data = %@",data.res);
            NSLog(@"USER-INFO Data = %@",data.msg);
            
            if ([data.res isEqual:@1]){
                // Store the data
                _usersSubs = [[NSArray alloc ]init];
                _userSub2 = [[NSArray alloc ]init];
                for(NSDictionary *item in data.info) {
                    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                    user.userId = [item valueForKeyPath:@"id"];
                    user.userName = [item valueForKeyPath:@"nom"];
                    if (user.userId != _trip.owner.userId){
                        _usersSubs = [_usersSubs arrayByAddingObject:user];
                    }
                    
                }
                 NSLog(@"USERSUB: %lu", self.usersSubs.count);
                [self.taulaUsers reloadData];
                
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"USERSUB: %lu", self.usersSubs.count);
    return self.usersSubs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
     NSLog(@"USERSUB: %lu", self.usersSubs.count);
    User* user = [self.usersSubs objectAtIndex:indexPath.row];
    cell.textLabel.text = user.userName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    User* user = [self.usersSubs objectAtIndex:indexPath.row];
    _userSub2 = [_userSub2 arrayByAddingObject:user];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)buttonSavePressed:(id)sender{
    
    NSLog(@"SUB2: %lu", self.userSub2.count);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    _trip.owner = user;
    for (User* userRead in self.userSub2){
        User* userSubs = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        userSubs.userId = userRead.userId;
        [WebServiceManager shareTripApiCall:_trip to:userSubs withCompletionHandler:^(WebResponse *data) {
            // Make sure that there is data.
            if (data != nil) {
                NSLog(@"LOGIN Data = %@",data.res);
                NSLog(@"LOGIN Data = %@",data.msg);
                
                if ([data.res isEqual:@1]){
                    
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
            }
        }];

    }
    [self.navigationController popViewControllerAnimated:YES];
    //[self performSegueWithIdentifier:@"saved" sender:self];
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
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
