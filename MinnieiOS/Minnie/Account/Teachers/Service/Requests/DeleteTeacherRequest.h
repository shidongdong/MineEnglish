//
//  DeleteTeacherRequest.h
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteTeacherRequest : BaseRequest

- (instancetype)initWithTeacherId:(NSUInteger)teacherId;

@end
