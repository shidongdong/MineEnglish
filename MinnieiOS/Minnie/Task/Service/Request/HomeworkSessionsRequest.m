//
//  HomeworkSessionsRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSessionsRequest.h"

@interface HomeworkSessionsRequest()

@property (nonatomic, assign) BOOL finished;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation HomeworkSessionsRequest

- (instancetype)initWithFinishState:(BOOL)finished {
    self = [super init];
    if (self != nil) {
        _finished = finished;
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
    
    return @{@"finished":(self.finished?@(1):@(0))};
}

@end

