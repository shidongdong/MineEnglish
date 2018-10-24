//
//  CreateClassRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CreateOrUpdateClassRequest.h"

@interface CreateOrUpdateClassRequest()

@property (nonatomic, strong) NSDictionary *dict;

@end

@implementation CreateOrUpdateClassRequest

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self != nil) {
        _dict = dict;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/create", ServerProjectName];
}

- (id)requestArgument {
    return self.dict;
}

@end

