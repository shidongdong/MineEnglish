//
//  UpdateTaskModifiedTimeRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/4/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "UpdateTaskModifiedTimeRequest.h"

@interface UpdateTaskModifiedTimeRequest()

@property (nonatomic, assign) NSInteger sessionId;

@end

@implementation UpdateTaskModifiedTimeRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _sessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/updateModifiedTime", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.sessionId)};
}

@end


