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

+ (BaseRequest *)requestTeachersWithCallback:(RequestCallback)callback;

// infos里面只包括一些修改过的内容
+ (BaseRequest *)updateTeacherWithInfos:(NSDictionary *)infos
                               callback:(RequestCallback)callback;

+ (BaseRequest *)createTeacherWithInfos:(NSDictionary *)infos
                               callback:(RequestCallback)callback;

+ (BaseRequest *)deleteTeacherWithId:(NSInteger)teacherId
                            callback:(RequestCallback)callback;

// 教师管理详情（ipad） 老师详情
+ (BaseRequest *)getTeacherDetailWithId:(NSInteger)teacherId
                            callback:(RequestCallback)callback;

@end
