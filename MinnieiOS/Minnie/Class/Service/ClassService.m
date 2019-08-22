//
//  ClassService.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "Clazz.h"
#import "ClassService.h"
#import "ClassesRequest.h"

@implementation ClassService

+ (BaseRequest *)requestClassWithId:(NSUInteger)classId
                           callback:(RequestCallback)callback {
    ClassRequest *request = [[ClassRequest alloc] initWithClassId:classId];
    
    request.objectClassName = @"Clazz";
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestClassesWithFinishState:(BOOL)finished
                                       listAll:(BOOL)listAll
                                        simple:(BOOL)simple
                                    campusName:(NSString *)campusName
                                      callback:(RequestCallback)callback {
    NSInteger teacherId = 0;
    if (!listAll) {
        teacherId = APP.currentUser.userId;
    }
    
    ClassesRequest *request = [[ClassesRequest alloc] initWithFinishState:finished teacherId:teacherId simple:simple campusName:campusName];
    
    request.objectKey = @"list";
    request.objectClassName = @"Clazz";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestNewClassesWithFinishState:(BOOL)finished
                                          listAll:(BOOL)listAll
                                           simple:(BOOL)simple
                                       campusName:(NSString *)campusName
                                         callback:(RequestCallback)callback {
    NSInteger teacherId = 0;
    if (!listAll) {
        teacherId = APP.currentUser.userId;
    }
    
    ClassesRequest *request = [[ClassesRequest alloc] initWithFinishState:finished teacherId:teacherId simple:simple campusName:campusName];
    
    request.objectKey = @"list";
    request.objectClassName = @"Clazz";
    request.callback = callback;
    [request start];
    
    return request;
}


+ (BaseRequest *)requestClassesWithNextUrl:(NSString *)nextUrl
                                  callback:(RequestCallback)callback {
    ClassesRequest *request = [[ClassesRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"Clazz";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)createOrUpdateClass:(NSDictionary *)dict
                            callback:(RequestCallback)callback {
    CreateOrUpdateClassRequest *request = [[CreateOrUpdateClassRequest alloc] initWithDict:dict];
    
    request.objectClassName = @"Clazz";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)deleteClassWithId:(NSUInteger)classId
                          callback:(RequestCallback)callback {
    DeleteClassRequest *request = [[DeleteClassRequest alloc] initWithClassId:classId];
    
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)addClassStudentWithClassId:(NSUInteger)classId
                                 studentIds:(NSArray<NSNumber *> *)studentIds
                                   callback:(RequestCallback)callback {
    AddClassStudentRequest *request = [[AddClassStudentRequest alloc] initWithClassId:classId
                                                                           studentIds:studentIds];
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)deleteClassStudentsWithClassId:(NSUInteger)classId
                                     studentIds:(NSArray<NSNumber *> *)studentIds
                                       callback:(RequestCallback)callback {
    DeleteClassStudentRequest *request = [[DeleteClassStudentRequest alloc] initWithClassId:classId studentIds:studentIds];
    
    request.callback = callback;
    [request start];
    
    return request;
}


// 2.5.8    获取所有班级列表（设置权限用）
+ (BaseRequest *)requestAllClassesWithCallback:(RequestCallback)callback{
    
    AllClassesRequest *request = [[AllClassesRequest alloc] init];
    request.objectKey = @"list";
    request.objectClassName = @"Clazz";
    request.callback = callback;
    [request start];
    
    return request;
}


@end


