//
//  MessageUpdateCountRequest.m
//  Minnie
//
//  Created by yebw on 2018/5/20.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "MessageUpdateCountRequest.h"

@implementation MessageUpdateCountRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/message/updateCount", ServerProjectName];
}

@end
