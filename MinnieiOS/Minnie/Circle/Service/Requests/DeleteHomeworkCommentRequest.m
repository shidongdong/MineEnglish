//
//  DeleteCommentRequest.m
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "DeleteHomeworkCommentRequest.h"

@interface DeleteHomeworkCommentRequest()

@property (nonatomic, assign) NSUInteger commentId;

@end

@implementation DeleteHomeworkCommentRequest

- (instancetype)initWithCommentId:(NSUInteger)commentId {
    self = [super init];
    if (self != nil) {
        _commentId = commentId;
    }

    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/deleteComment", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.commentId)};
}

@end

