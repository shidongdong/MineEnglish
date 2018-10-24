//
//  TrialClasssRequest.m
//  MinnieStudent
//
//  Created by yebw on 2018/4/14.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "TrialClasssRequest.h"

@implementation TrialClasssRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/classes", ServerProjectName];
}

- (id)requestArgument {
    return @{@"trial":@(1), @"finished":@(0), @"simple":@(1)};
}

@end
