//
//  ClassService.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ClassService.h"
#import "ClassesRequest.h"
#import "CreateOrUpdateClassRequest.h"
#import "HomeworksRequest.h"
#import "DeleteClassRequest.h"
#import "Clazz.h"
#import "ClassRequest.h"
#import "AddClassStudentRequest.h"
#import "DeleteClassStudentRequest.h"

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
                                      callback:(RequestCallback)callback {
    NSInteger teacherId = 0;
    if (!listAll) {
        teacherId = APP.currentUser.userId;
    }
    
    ClassesRequest *request = [[ClassesRequest alloc] initWithFinishState:finished teacherId:teacherId simple:simple];
    
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

+ (BaseRequest *)requestClassHomeworksWithClassId:(NSUInteger)classId
                                         callback:(RequestCallback)callback {
    HomeworksRequest *request = [[HomeworksRequest alloc] initWithClassId:classId];
    
    request.objectKey = @"list";
    request.objectClassName = @"Homework";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestClassHomeworksWithNextUrl:(NSString *)nextUrl
                                         callback:(RequestCallback)callback {
    HomeworksRequest *request = [[HomeworksRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"Homework";
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

@end


