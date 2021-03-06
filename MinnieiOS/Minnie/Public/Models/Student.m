//
//  Student.m
//  X5
//
//  Created by yebw on 2018/4/6.
//  Copyright © 2018年 mfox. All rights reserved.
//

#import "Student.h"
#import "Clazz.h"

@implementation Student

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userId":@"id",   // 用户id
             @"username":@"username", // 用户名
             @"nickname":@"nickname", // 昵称
             @"phoneNumber":@"phoneNumber", // 电话号码
             @"gender":@"gender", //  性别
             @"avatarUrl":@"avatarUrl", // 头像地址
             @"token":@"token", // token
             @"grade":@"grade", // 年级
             @"starCount":@"starCount", // 星星数
             @"circleUpdate":@"circleUpdate", // 朋友圈更新
             @"homeworks":@"homeworks", // 作业情况数组
             @"clazz":@"class", // 所在班级信息，可能没有
             @"enrollState":@"enrollState" // 报名状态
             };
}

+ (NSValueTransformer *)clazzTeacherJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Clazz class]];
}

@end



