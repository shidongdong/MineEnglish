//
//  DeleteCommentRequest.m
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "DeleteCircleHomeworkRequest.h"

@interface DeleteCircleHomeworkRequest()

@property (nonatomic, assign) NSUInteger homeworkId;

@end

@implementation DeleteCircleHomeworkRequest

- (instancetype)initWithHomeworkId:(NSUInteger)homeworkId {
    self = [super init];
    if (self != nil) {
        _homeworkId = homeworkId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/delete", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.homeworkId)};
}

@end


