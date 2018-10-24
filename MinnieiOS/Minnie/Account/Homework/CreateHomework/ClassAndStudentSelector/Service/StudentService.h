//
//  StudentsService.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Result.h"

@interface StudentService : NSObject

+ (BaseRequest *)requestStudentsWithFinishState:(BOOL)finished
                                       callback:(RequestCallback)callback;

+ (BaseRequest *)requestStudentsWithClassState:(BOOL)inClass
                                      callback:(RequestCallback)callback;

+ (BaseRequest *)requestStudentsWithNextUrl:(NSString *)nextUrl
                                   callback:(RequestCallback)callback;

+ (BaseRequest *)requestStudentWithPhoneNumber:(NSString *)phoneNumber
                                      callback:(RequestCallback)callback;


@end


