//
//  DeleteClassStudentRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteClassStudentRequest : BaseRequest

- (instancetype)initWithClassId:(NSUInteger)classId
                     studentIds:(NSArray <NSNumber *> *)studentIds;

@end
