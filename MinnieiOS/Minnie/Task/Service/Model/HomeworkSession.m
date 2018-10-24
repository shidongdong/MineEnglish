//
//  HomeworkSession.m
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkSession.h"

@implementation HomeworkSession

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"homeworkSessionId":@"id",
             @"student":@"student",
             @"homework":@"homework",
             @"correctTeacher":@"correctTeacher",
             @"imageUrl":@"imageUrl",
             @"videoUrl":@"videoUrl",
             @"sendTime":@"sendTime",
             @"updateTime":@"updateTime",
             @"score":@"score",
             @"reviewText":@"content",
             @"isRedo":@"isRedo",
             };
}

+ (NSValueTransformer *)studentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)correctTeacherJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)homeworkJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Homework class]];
}

@end


