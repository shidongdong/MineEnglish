//
//  RedoHomeworkRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/4/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "RedoHomeworkRequest.h"

@interface RedoHomeworkRequest()

@property (nonatomic, assign) NSInteger sessionId;

@end

@implementation RedoHomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _sessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/redoHomework", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.sessionId)};
}

@end
