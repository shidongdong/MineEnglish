//
//  StudentStarRankRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StudentStarRankRequest.h"

@implementation StudentStarRankRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/user/getStarRank", ServerProjectName];
}


@end
