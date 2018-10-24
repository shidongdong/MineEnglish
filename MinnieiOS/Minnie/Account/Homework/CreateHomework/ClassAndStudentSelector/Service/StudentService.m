//
//  StudentsService.m
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "StudentService.h"
#import "StudentsRequest.h"
#import "StudentRequest.h"

@implementation StudentService

+ (BaseRequest *)requestStudentsWithFinishState:(BOOL)finished
                                       callback:(RequestCallback)callback {
    StudentsRequest *request = [[StudentsRequest alloc] initWithFinishState:finished];
    
    request.objectKey = @"list";
    request.objectClassName = @"User";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestStudentsWithClassState:(BOOL)inClass
                                      callback:(RequestCallback)callback {
    StudentsRequest *request = [[StudentsRequest alloc] initWithClassState:inClass];
    
    request.objectKey = @"list";
    request.objectClassName = @"User";
    request.callback = callback;
    [request start];
    
    return request;
}


+ (BaseRequest *)requestStudentsWithNextUrl:(NSString *)nextUrl
                                   callback:(RequestCallback)callback {
    StudentsRequest *request = [[StudentsRequest alloc] initWithNextUrl:nextUrl];
    
    request.objectKey = @"list";
    request.objectClassName = @"User";
    request.callback = callback;
    [request start];
    
    return request;
}

+ (BaseRequest *)requestStudentWithPhoneNumber:(NSString *)phoneNumber
                                      callback:(RequestCallback)callback {
    StudentRequest *request = [[StudentRequest alloc] initWithPhoneNumber:phoneNumber];
    
    request.objectClassName = @"Student";
    request.callback = callback;
    [request start];
    
    return request;
}

@end


