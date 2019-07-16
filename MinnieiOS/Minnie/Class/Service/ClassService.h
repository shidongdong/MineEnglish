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

+ (BaseRequest *)requestClassWithId:(NSUInteger)classId
                           callback:(RequestCallback)callback;

// 获取班级列表（学生端，教师端，ipad端）
+ (BaseRequest *)requestClassesWithFinishState:(BOOL)finished
                                       listAll:(BOOL)listAll
                                        simple:(BOOL)simple
                                    campusName:(NSString *)campusName
                                      callback:(RequestCallback)callback;

+ (BaseRequest *)requestClassesWithNextUrl:(NSString *)nextUrl
                                  callback:(RequestCallback)callback;

+ (BaseRequest *)requestClassHomeworksWithClassId:(NSUInteger)classId
                                         callback:(RequestCallback)callback;

+ (BaseRequest *)requestClassHomeworksWithNextUrl:(NSString *)nextUrl
                                         callback:(RequestCallback)callback;

+ (BaseRequest *)createOrUpdateClass:(NSDictionary *)dict
                            callback:(RequestCallback)callback;

+ (BaseRequest *)deleteClassWithId:(NSUInteger)classId
                          callback:(RequestCallback)callback;

+ (BaseRequest *)addClassStudentWithClassId:(NSUInteger)classId
                                 studentIds:(NSArray<NSNumber *> *)studentIds
                                   callback:(RequestCallback)callback;

+ (BaseRequest *)deleteClassStudentsWithClassId:(NSUInteger)classId
                                     studentIds:(NSArray<NSNumber *> *)studentIds
                                       callback:(RequestCallback)callback;

@end



