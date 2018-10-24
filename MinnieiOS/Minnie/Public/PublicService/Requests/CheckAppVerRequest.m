//
//  CheckAppVerRequest.m
//  MinnieStudent
//
//  Created by 栋栋 施 on 2018/9/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CheckAppVerRequest.h"

@interface CheckAppVerRequest()

@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * type;
@end

@implementation CheckAppVerRequest

- (instancetype)initWithVersion:(NSString *)version  withType:(NSString *)type{
    self = [super init];
    if (self != nil) {
        _version = version;
        _type = type;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/app/getUpgradeInfo", ServerProjectName];
}

- (id)requestArgument {
    return @{@"os":@(2),@"type":_type,@"version" : _version};
}

@end
