//
//  PublicService.m
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "PublicService.h"
#import "UserRequest.h"
#import "CheckAppVerRequest.h"
#import "AppVersion.h"
#import "ModifyStarRequest.h"
@implementation PublicService

+ (BaseRequest *)requestUserInfoWithId:(NSInteger)userId
                              callback:(RequestCallback)callback {
    UserRequest *request = [[UserRequest alloc] initWithUserId:userId];

#if TEACHERSIDE | MANAGERSIDE
    request.objectClassName = @"Teacher";
#else
    request.objectClassName = @"Student";
#endif
    request.callback = callback;
    [request start];

    return request;
}

+ (BaseRequest *)requestAppUpgradeWithVersion:(NSString *)version
                                 callback:(RequestCallback)callback {
    
#if TEACHERSIDE | MANAGERSIDE
    NSString * type = @"1";
#else
    NSString * type = @"0";
#endif
    
    CheckAppVerRequest *request = [[CheckAppVerRequest alloc] initWithVersion:version withType:type];
    request.objectClassName = @"AppVersion";
    request.callback = callback;
    [request start];
    return request;
}

+ (BaseRequest *)requestStudentInfoWithId:(NSInteger)userId
                                 callback:(RequestCallback)callback {
    UserRequest *request = [[UserRequest alloc] initWithUserId:userId];

    request.objectClassName = @"Student";
    request.callback = callback;
    [request start];
    
    return request;
}


+ (BaseRequest *)modifyStarCount:(NSInteger)count
                      forStudent:(NSInteger)studentId
                          reason:(NSString *)reason
                        callback:(RequestCallback)callback
{
    ModifyStarRequest *request = [[ModifyStarRequest alloc] initWithStudentId:studentId starCount:count reason:reason];
    request.callback = callback;
    [request start];
    return request;
}
@end
