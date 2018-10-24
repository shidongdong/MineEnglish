//
//  StudentRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/2/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "StudentRequest.h"

@interface StudentRequest()

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *name;

@end

@implementation StudentRequest

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber {
    self = [super init];
    if (self != nil) {
        _phoneNumber = phoneNumber;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/auth/user", ServerProjectName];
}

- (id)requestArgument {
    NSMutableDictionary *arg = [NSMutableDictionary dictionary];
    if (self.phoneNumber.length > 0) {
        arg[@"phoneNumber"] = self.phoneNumber;
    }

    return arg;
}

@end

