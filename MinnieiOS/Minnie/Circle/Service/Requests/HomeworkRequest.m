//
//  HomeworkRequest.m
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworkRequest.h"

@interface HomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;

@end

@implementation HomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/homeworkTask", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkSessionId)};
}

@end

