//
//  UnlikeHomeworkRequest.m
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "UnlikeHomeworkRequest.h"

@interface UnlikeHomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;

@end

@implementation UnlikeHomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
    }

    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/unlike", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkSessionId)};
}

@end

