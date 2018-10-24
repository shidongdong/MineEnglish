//
//  UnexchangedRequestCountRequest.m
//  MinnieTeacher
//
//  Created by yebw on 2018/5/20.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "UnexchangedRequestCountRequest.h"

@implementation UnexchangedRequestCountRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/award/unexchangedOrdersCount", ServerProjectName];
}

@end
