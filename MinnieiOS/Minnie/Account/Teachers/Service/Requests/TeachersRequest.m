//
//  TeachersRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TeachersRequest.h"

#pragma mark - 2.3.8    获取所有教师列表（教师端）
@implementation TeachersRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teachers", ServerProjectName];
}

@end



#pragma mark - 2.8.1    新建/编辑教师（教师端）
@interface CreateTeacherRequest()

@property (nonatomic, strong) NSDictionary *infos;

@end

@implementation CreateTeacherRequest

- (instancetype)initWithInfos:(NSDictionary *)infos {
    self = [super init];
    if (self != nil) {
        _infos = infos;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/create", ServerProjectName];
}

- (id)requestArgument {
    return self.infos;
}

@end



#pragma mark - 2.8.2    删除教师（教师端）
@interface DeleteTeacherRequest()

@property (nonatomic, assign) NSUInteger teacherId;

@end

@implementation DeleteTeacherRequest

- (instancetype)initWithTeacherId:(NSUInteger)teacherId {
    self = [super init];
    if (self != nil) {
        _teacherId = teacherId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    if (USING_MOCK_DATA) {
        return YTKRequestMethodGET;
    }
    
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/delete", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.teacherId)};
}


@end



#pragma mark - 2.8.3    教师管理详情（ipad）
@interface TeacherDetailRequest ()

@property (nonatomic,assign) NSInteger teacherId;

@end

@implementation TeacherDetailRequest

- (instancetype)initWithTeacherId:(NSInteger)teacherId
{
    self = [super init];
    if (self) {
        
        _teacherId = teacherId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/teacherDetail", ServerProjectName];
}

- (id)requestArgument {//1478
    return @{@"teacherId":@(self.teacherId)};
}

@end

#pragma mark - 2.8.4    获取所有教师（权限修改）
@implementation ALLTeachersRequest


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/getAllTeachers", ServerProjectName];
}


@end
