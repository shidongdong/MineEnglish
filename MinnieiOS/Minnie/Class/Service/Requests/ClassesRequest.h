//
//  ClassesRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

//2.5.1    获取班级列表（学生端，教师端，ipad端）
@interface ClassesRequest : BaseRequest

- (instancetype)initWithFinishState:(BOOL)finished
                          teacherId:(NSInteger)teacherId
                             simple:(BOOL)simple
                         campusName:(NSString *)campusName;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end


//2.5.8    获取所有班级列表（设置权限用）
@interface AllClassesRequest : BaseRequest

@end

