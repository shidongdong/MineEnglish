//
//  LikeHomeworkRequest.m
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "LikeHomeworkRequest.h"

@interface LikeHomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;

@end

@implementation LikeHomeworkRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/like", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkSessionId)};
}

@end

