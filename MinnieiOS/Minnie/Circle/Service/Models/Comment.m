//
//  Comment.m
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"commentId":@"id",
             @"homeworkSessionId":@"taskId",
             @"user":@"user",
             @"content":@"content",
             @"originalComment":@"originalComment",
             @"time":@"time",
             @"deleted":@"deleted",
             @"videoUrl":@"videoUrl"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)originalCommentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Comment class]];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Comment class]]) {
        return NO;
    }
    
    Comment *comment = (Comment *)object;
    
    if (self == object) {
        return YES;
    }

    return comment.commentId == self.commentId;
}

@end
