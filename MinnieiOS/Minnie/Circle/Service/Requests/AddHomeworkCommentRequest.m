//
//  AddCommentRequest.m
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "AddHomeworkCommentRequest.h"

@interface AddHomeworkCommentRequest()

@property (nonatomic, assign) NSUInteger homeworkSessionId;
@property (nonatomic, assign) NSUInteger commentId;
@property (nonatomic, copy) NSString *content;

@end

@implementation AddHomeworkCommentRequest

- (id)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId
                      commentId:(NSUInteger)commentId
                        content:(NSString *)content {
    self = [super init];
    if (self != nil) {
        _homeworkSessionId = homeworkSessionId;
        _commentId = commentId;
        _content = content;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/circle/addComment", ServerProjectName];
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"id"] = @(self.homeworkSessionId);
    if (self.commentId > 0) {
        dict[@"originalCommentId"] = @(self.commentId);
    }
    dict[@"content"] = self.content;
    
    return dict;
}

@end



