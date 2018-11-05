//
//  ImagesListController.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 29/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "ImagesListController.h"

@implementation ImagesListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:self.managedObjectContext];
    trip.tripId = [defaults objectForKey:@"Trip"];
    NSLog(@"TRIPID = %@",[defaults objectForKey:@"Trip"]);
    
    [self downloadData:user in:[defaults objectForKey:@"Trip"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    [recipeImageView setUserInteractionEnabled:YES];
    Image* image = [self.images objectAtIndex:indexPath.row];
    NSURL *imgURL = [NSURL URLWithString:image.imagePath];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *img = [[UIImage alloc] initWithData:data];
            [recipeImageView setImage:img];
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionViewCell *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Image* image = [self.images objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    user.email = [defaults objectForKey:@"User"];
    user.password = [defaults objectForKey:@"Password"];
    NSString * tripid = [defaults objectForKey:@"Trip"];
    
    [WebServiceManager removeImageApiCall:user for:tripid and:[NSString stringWithFormat:@"%@", image.imageId]withCompletionHandler:^(WebResponse *data) {
        // Make sure that there is data.
        if (data != nil) {
            NSLog(@"IMAGE-REMOVE Data = %@",data.res);
            NSLog(@"IMAGE-REMOVE Data = %@",data.msg);
            
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

    
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
                        
                        NSArray* images = [item valueForKeyPath:@"img"];
                        NSArray* imagesArray = [[NSArray alloc ]init];
                        for(NSDictionary *itemImg in images) {
                            Image* image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
                            image.imageId = [itemImg valueForKeyPath:@"id"];
                            image.imageName = [itemImg valueForKeyPath:@"nom"];
                            image.imagePath = [itemImg valueForKeyPath:@"path"];
                            imagesArray = [imagesArray arrayByAddingObject:image];
                            
                        }
                        self.images = imagesArray;
                        NSLog(@"Images count COP: %lu", (unsigned long)self.images.count);
                        NSLog(@"Images count GET: %lu", (unsigned long)imagesArray.count);
                    }
                }
                [self.collectionView reloadData];
                
            }else{
                
                [[[UIAlertView alloc]initWithTitle:@"Error" message:data.msg delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error connecting with Web Service" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil]show];
        }
    }];
    
}


@end
