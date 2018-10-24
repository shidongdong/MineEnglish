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

@interface MyClassService : NSObject

+ (BaseRequest *)requestClassWithId:(NSUInteger)classId
                           callback:(RequestCallback)callback;

@end


