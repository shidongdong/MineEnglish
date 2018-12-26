//
//  CorrectHomeworkCommentsRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkCommentsRequest.h"

@implementation CorrectHomeworkCommentsRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/comments", ServerProjectName];
}

@end
