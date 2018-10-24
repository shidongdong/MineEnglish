//
//  HomeworkSessionsRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSessionRequest.h"

@interface HomeworkSessionRequest()

@property (nonatomic, assign) NSInteger homeworkId;

@end

@implementation HomeworkSessionRequest

- (instancetype)initWithId:(NSInteger)homeworkId {
    self = [super init];
    if (self != nil) {
        _homeworkId = homeworkId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/detail", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkId)};
}

@end

