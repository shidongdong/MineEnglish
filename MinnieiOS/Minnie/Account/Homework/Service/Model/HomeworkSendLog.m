//
//  HomeworkSendLog.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkSendLog.h"

@implementation HomeworkSendLog

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"teacherName":@"teacherName",
             @"homeworkTitles":@"homeworkTitles",
             @"classNames":@"classNames",
             @"studentNames":@"studentNames",
             @"createTime":@"createTime",
             };
}

@end
