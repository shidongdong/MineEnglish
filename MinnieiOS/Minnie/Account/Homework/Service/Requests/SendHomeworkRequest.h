//
//  SendHomeworkRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface SendHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkIds:(NSArray <NSNumber *> *)homeworkIds
                           classIds:(NSArray <NSNumber *> *)classIds
                         studentIds:(NSArray <NSNumber *> *)studentIds
                          teacherId:(NSInteger)teacherId
                               date:(NSDate *)date;

@end

