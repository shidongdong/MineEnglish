//
//  UpdateProfileRequest.m
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "UpdateProfileRequest.h"

@interface UpdateProfileRequest()

@property (nonatomic, copy) NSDictionary *profileDict;

@end

@implementation UpdateProfileRequest

- (instancetype)initWithProfileDict:(NSDictionary *)dict {
    self = [super init];
    if (self != nil) {
        _profileDict = dict;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/updateUserInfo", ServerProjectName];
}

- (id)requestArgument {
    return self.profileDict;
}

@end

