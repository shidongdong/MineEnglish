//
//  SendHomeworkHistoryRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "SendHomeworkHistoryRequest.h"

@interface SendHomeworkHistoryRequest()

@property(nonatomic,copy)NSString * nextUrl;

@end

@implementation SendHomeworkHistoryRequest


- (instancetype)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    return self;
}


- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/homework/getHomeworkSendLog", ServerProjectName];
}

@end
