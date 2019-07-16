//
//  HomeworkSessionsRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSessionsRequest.h"

@interface HomeworkSessionsRequest()

@property (nonatomic, assign) NSInteger finished;  //0表示未完成，1表示已完成  2未提交
@property (nonatomic, copy) NSString *nextUrl;
@property (nonatomic, assign) NSInteger teacherId;

@end

@implementation HomeworkSessionsRequest

- (instancetype)initWithFinishState:(NSInteger)finished teacherId:(NSInteger)teacherId{
    self = [super init];
    if (self != nil) {
        _finished = finished;
        _teacherId = teacherId;
    }
    
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }

    return [NSString stringWithFormat:@"%@/homeworkTask/homeworkTasks", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    if (self.teacherId == 0) {
        
        return @{@"finished":@(self.finished)};
    } else {
        return @{@"finished":@(self.finished),
                 @"teacherId":@(self.teacherId)};
    }
}

@end

