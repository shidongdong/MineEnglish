//
//  ClassesRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

// 接口请求太慢，弃用
#pragma mark - 2.5.1    获取班级列表（学生端，教师端，ipad端）
@interface ClassesRequest : BaseRequest

- (instancetype)initWithFinishState:(BOOL)finished
                          teacherId:(NSInteger)teacherId
                             simple:(BOOL)simple
                         campusName:(NSString *)campusName;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end


#pragma mark - 2.5.2    获取班级列表new
@interface NewClassesRequest : BaseRequest

- (instancetype)initWithFinishState:(BOOL)finished
                          teacherId:(NSInteger)teacherId
                             simple:(BOOL)simple
                         campusName:(NSString *)campusName;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end


#pragma mark - 2.5.3    获取班级详情（学生端，教师端）
@interface ClassRequest : BaseRequest

- (instancetype)initWithClassId:(NSUInteger)classId;

@end


#pragma mark - 2.5.4    新建或更新班级信息（教师端）
@interface CreateOrUpdateClassRequest : BaseRequest

- (instancetype)initWithDict:(NSDictionary *)dict;

@end


#pragma mark - 2.5.5    删除班级（教师端）
@interface DeleteClassRequest : BaseRequest

- (instancetype)initWithClassId:(NSUInteger)classId;

@end



#pragma mark - 2.5.6    班级添加学生（教师端）
@interface AddClassStudentRequest : BaseRequest

- (instancetype)initWithClassId:(NSUInteger)classId
                     studentIds:(NSArray <NSNumber *> *)studentIds;

@end



#pragma mark - 2.5.7    班级删除学生（教师端）
@interface DeleteClassStudentRequest : BaseRequest

- (instancetype)initWithClassId:(NSUInteger)classId
                     studentIds:(NSArray <NSNumber *> *)studentIds;

@end



#pragma mark - 2.5.9    获取所有班级列表（设置权限用）
@interface AllClassesRequest : BaseRequest

@end

