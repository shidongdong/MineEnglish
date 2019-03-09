//
//  AskQNTokenRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/1.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "AskQNTokenRequest.h"

@implementation AskQNTokenRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/qiniu/getUpToken", ServerProjectName];
}

@end
