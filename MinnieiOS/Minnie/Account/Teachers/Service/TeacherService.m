//
//  TeacherService.m
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TeacherService.h"
#import "TeachersRequest.h"
//#import "CreateTeacherRequest.h"
//#import "UpdateTeacherRequest.h"
//#import "DeleteTeacherRequest.h"

@implementation TeacherService

+ (BaseRequest *)requestTeachersWithCallback:(RequestCallback)callback {
    TeachersRequest *request = [[TeachersRequest alloc] init];
    
    request.objectKey = @"list";
    request.objectClassName = @"Teacher";
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

+ (BaseRequest *)updateTeacherWithInfos:(NSDictionary *)infos
                               callback:(RequestCallback)callback {
    CreateTeacherRequest *request = [[CreateTeacherRequest alloc] initWithInfos:infos];
    
    request.objectClassName = @"Teacher";
    request.callback = callback;
    
    [request start];
    
    return request;
}

#pragma mark - 2.8.1    新建/编辑教师（教师端）
+ (BaseRequest *)createTeacherWithInfos:(NSDictionary *)infos
                               callback:(RequestCallback)callback {
    CreateTeacherRequest *request = [[CreateTeacherRequest alloc] initWithInfos:infos];
    
    request.objectClassName = @"Teacher";
    request.callback = callback;
    
    [request start];
    
    return request;
}

+ (BaseRequest *)deleteTeacherWithId:(NSInteger)teacherId
                            callback:(RequestCallback)callback {
    DeleteTeacherRequest *request = [[DeleteTeacherRequest alloc] initWithTeacherId:teacherId];
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

+ (BaseRequest *)getTeacherDetailWithId:(NSInteger)teacherId
                               callback:(RequestCallback)callback{
    
    TeacherDetailRequest *request = [[TeacherDetailRequest alloc] initWithTeacherId:teacherId];
    
    request.objectClassName = @"TeacherDetail";
    request.callback = callback;
    [request start];
    return request;
    
}

// 获取所有教师（权限修改）
+ (BaseRequest *)getAllTeacherWithCallback:(RequestCallback)callback{
    
    ALLTeachersRequest *request = [[ALLTeachersRequest alloc] init];
    request.objectKey = @"list";
    request.objectClassName = @"Teacher";
    request.callback = callback;
    
    [request start];
    
    return request;
}
@end

