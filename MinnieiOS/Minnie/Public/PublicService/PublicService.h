//
//  PublicService.h
//  X5
//
//  Created by yebw on 2017/12/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Result.h"

@interface PublicService : NSObject

+ (BaseRequest *)requestUserInfoWithId:(NSInteger)userId
                              callback:(RequestCallback)callback;

+ (BaseRequest *)requestStudentInfoWithId:(NSInteger)userId
                                 callback:(RequestCallback)callback;

+ (BaseRequest *)requestAppUpgradeWithVersion:(NSString *)version
                                     callback:(RequestCallback)callback;
// 修改学生星星数量 可用
+ (BaseRequest *)modifyStarCount:(NSInteger)count
                      forStudent:(NSInteger)studentId
                          reason:(NSString *)reason
                        callback:(RequestCallback)callback;

@end
