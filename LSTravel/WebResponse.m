//
//  WebResponse.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 27/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "WebResponse.h"

@implementation WebResponse

- (NSString*)getRes {
    return _res;
}
- (void)setRes:(NSString*)newValue {
    _res = newValue;
}

- (NSString*)getMsg {
    return _msg;
}
- (void)setMsg:(NSString*)newValue {
    _msg = newValue;
}

- (NSArray*)getInfo {
    return _info;
}
- (void)setInfo:(NSArray*)newValue {
    _info = newValue;
}

@end
