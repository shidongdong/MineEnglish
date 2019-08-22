//
//  ClassService.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "Clazz.h"
#import "MyClassService.h"
#import "MyClassRequest.h"

@implementation MyClassService

+ (BaseRequest *)requestClassWithId:(NSUInteger)classId
                           callback:(RequestCallback)callback {
    MyClassRequest *request = [[MyClassRequest alloc] initWithClassId:classId];
    
    request.objectClassName = @"Clazz";
    
    request.callback = callback;
    [request start];
    
    return request;
}

@end

