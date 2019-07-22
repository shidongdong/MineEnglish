//
//  Teacher.m
//  X5Teacher
//
//  Created by yebw on 2017/12/29.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userId":@"id",
             @"username":@"username",
             @"nickname":@"nickname",
             @"phoneNumber":@"phoneNumber",
             @"gender":@"gender",
             @"avatarUrl":@"avatarUrl",
             @"token":@"token",
             @"type":@"type",
             @"authority":@"authority",
             @"canManageHomeworks":@"canManageHomeworks",
             @"canManageClasses":@"canManageClasses",
             @"canManageStudents":@"canManageStudents",
             @"canCreateRewards":@"canCreateRewards",
             @"canExchangeRewards":@"canExchangeRewards",
             @"canCreateNoticeMessage":@"canCreateNoticeMessage"
             };
}

- (NSString *)typeDescription {
    NSString *type = nil;
    if (self.type == TeacherTypeTeacher) {
        type = @"教师";
    } else if (self.type == TeacherTypeAssistant) {
        type = @"助教";
    }
    
    return type;
}

- (NSString *)authorityDescription {
    NSString *authority = nil;
    if (self.authority == TeacherAuthoritySuperManager) {
        authority = @"超级管理员";
    } else if (self.authority == TeacherAuthorityManager) {
        authority = @"管理员";
    } else if (self.authority == TeacherAuthorityTeacher) {
        authority = @"普通教师";
    }
    
    return authority;
}

@end


@implementation OnClass

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
   
    return @{@"classId":@"id",
             @"name":@"name",
             @"studentCount":@"studentCount"
             };
}

@end


@implementation OnHomework

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  
    return @{@"homeworkId":@"id",
             @"title":@"title",
             @"avgScore":@"avgScore",
             @"level":@"level"
             };
}

@end


@implementation TeacherDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"isOnline":@"isOnline",
             @"onlineDetail":@"onlineDetail",
             @"uncommitedHomeworksCount":@"uncommitedHomeworksCount",
             @"uncorrectedHomeworksCount":@"uncorrectedHomeworksCount",
             @"correctedHomeworksDetail":@"correctedHomeworksDetail",
             @"onClassList":@"onClassList",
             @"onHomeworkList":@"onHomeworkList"
             };
}


@end
