//
//  UserRequest.m
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "UserRequest.h"

@interface UserRequest()

@property (nonatomic, assign) NSInteger userId;

@end

@implementation UserRequest

- (instancetype)initWithUserId:(NSInteger)userId {
    self = [super init];
    if (self != nil) {
        _userId = userId;
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
    return @{@"id":@(self.userId)};
}

@end

