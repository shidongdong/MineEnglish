//
//  TeachersRequest.h
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseRequest.h"

#pragma mark - 2.3.8    获取所有教师列表（教师端）
@interface TeachersRequest : BaseRequest

@end


#pragma mark - 2.8.1    新建/编辑教师（教师端）
@interface CreateTeacherRequest : BaseRequest

- (instancetype)initWithInfos:(NSDictionary *)infos;

@end


#pragma mark - 2.8.2    删除教师（教师端）

@interface DeleteTeacherRequest : BaseRequest

- (instancetype)initWithTeacherId:(NSUInteger)teacherId;

@end


#pragma mark - 2.8.3    教师管理详情（ipad）
@interface TeacherDetailRequest : BaseRequest

- (instancetype)initWithTeacherId:(NSInteger)teacherId;

@end


#pragma mark - 2.8.4    获取所有教师（权限修改）
@interface ALLTeachersRequest : BaseRequest

@end
