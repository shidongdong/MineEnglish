//
//  ClassService.h
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "BaseRequest.h"

@interface ClassService : NSObject

// 接口请求太慢，弃用
#pragma mark - 2.5.1    获取班级列表（学生端，教师端，ipad端）
+ (BaseRequest *)requestClassesWithFinishState:(BOOL)finished
                                       listAll:(BOOL)listAll
                                        simple:(BOOL)simple
                                    campusName:(NSString *)campusName
                                      callback:(RequestCallback)callback;

+ (BaseRequest *)requestClassesWithNextUrl:(NSString *)nextUrl
                                  callback:(RequestCallback)callback;



#pragma mark - 2.5.2    获取班级列表new
+ (BaseRequest *)requestNewClassesWithFinishState:(BOOL)finished
                                       campusName:(NSString *)campusName
                                         callback:(RequestCallback)callback;


#pragma mark - 2.5.3    获取班级详情（学生端，教师端）
+ (BaseRequest *)requestClassWithId:(NSUInteger)classId
                           callback:(RequestCallback)callback;


#pragma mark - 2.5.4    新建或更新班级信息（教师端）
+ (BaseRequest *)createOrUpdateClass:(NSDictionary *)dict
                            callback:(RequestCallback)callback;


#pragma mark - 2.5.5    删除班级（教师端）
+ (BaseRequest *)deleteClassWithId:(NSUInteger)classId
                          callback:(RequestCallback)callback;


#pragma mark - 2.5.6    班级添加学生（教师端）
+ (BaseRequest *)addClassStudentWithClassId:(NSUInteger)classId
                                 studentIds:(NSArray<NSNumber *> *)studentIds
                                   callback:(RequestCallback)callback;


#pragma mark - 2.5.7    班级删除学生（教师端）
+ (BaseRequest *)deleteClassStudentsWithClassId:(NSUInteger)classId
                                     studentIds:(NSArray<NSNumber *> *)studentIds
                                       callback:(RequestCallback)callback;


#pragma mark - 2.5.9    获取所有班级列表（设置权限用）
+ (BaseRequest *)requestAllClassesWithCallback:(RequestCallback)callback;

@end



