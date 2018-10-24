//
//  CircleHomework.m
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleHomework.h"

@implementation CircleHomework

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"homeworkSessionId":@"id",
             @"student":@"student",
//             @"homework":@"homework",
             @"imageUrl":@"imageUrl",
             @"videoUrl":@"videoUrl",
             @"score":@"score",
             @"reviewText":@"content",
             @"likeUsers":@"likeUsers",
             @"commentCount":@"commentCount",
             @"comments":@"comments",
             @"liked":@"liked",
             @"commitTime":@"commitTime"
             };
}

+ (NSValueTransformer *)studentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

//+ (NSValueTransformer *)homeworkJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Homework class]];
//}

+ (NSValueTransformer *)likeUsersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Comment class]];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CircleHomework class]]) {
        return NO;
    }
    
    CircleHomework *homework = (CircleHomework *)object;
    
    if (self == object) {
        return YES;
    }

    return homework.homeworkSessionId == self.homeworkSessionId;
}

@end

