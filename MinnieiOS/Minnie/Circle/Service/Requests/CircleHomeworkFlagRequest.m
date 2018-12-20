//
//  CircleHomeworkFlagRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/17.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CircleHomeworkFlagRequest.h"

@implementation CircleHomeworkFlagRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/getCircleNoticeFlag", ServerProjectName];
}

@end
