//
//  TeacherService.h
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Result.h"

@interface TeacherService : NSObject

#pragma mark - 2.3.8    获取所有教师列表（教师端）
+ (BaseRequest *)requestTeachersWithCallback:(RequestCallback)callback;


#pragma mark - 2.8.1    新建/编辑教师（教师端）
+ (BaseRequest *)createTeacherWithInfos:(NSDictionary *)infos
                               callback:(RequestCallback)callback;
// infos里面只包括一些修改过的内容
+ (BaseRequest *)updateTeacherWithInfos:(NSDictionary *)infos
                               callback:(RequestCallback)callback;


#pragma mark - 2.8.2    删除教师（教师端）
+ (BaseRequest *)deleteTeacherWithId:(NSInteger)teacherId
                            callback:(RequestCallback)callback;


#pragma mark - 2.8.3    教师管理详情（ipad）
+ (BaseRequest *)getTeacherDetailWithId:(NSInteger)teacherId
                            callback:(RequestCallback)callback;


#pragma mark - 2.8.4    获取所有教师（权限修改）
+ (BaseRequest *)getAllTeacherWithCallback:(RequestCallback)callback;

@end
