//
//  WebResponse.h
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 27/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebResponse : NSObject

@property (strong, nonatomic) NSString * res;
@property (strong, nonatomic) NSString * msg;
@property (strong, nonatomic) NSArray * info;

- (NSString*)getRes;
- (void)setRes:(NSString*)newValue;

- (NSString*)getMsg;
- (void)setMsg:(NSString*)newValue;

- (NSArray*)getInfo;
- (void)setInfo:(NSArray*)newValue;

@end
