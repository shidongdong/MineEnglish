//
//  AchieverUpdateFlagRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AchieverUpdateFlagRequest.h"

@implementation AchieverUpdateFlagRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/medal/updateMedalNoticeFlag", ServerProjectName];
}


@end
