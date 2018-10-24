//
//  UnreaderCircleCountRequest.m
//  Minnie
//
//  Created by yebw on 2018/5/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "UnreaderCircleCountRequest.h"

@implementation UnreaderCircleCountRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/updateCount", ServerProjectName];
}

@end
