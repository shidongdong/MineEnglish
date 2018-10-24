//
//  ClassesRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface ClassesRequest : BaseRequest

- (instancetype)initWithFinishState:(BOOL)finished teacherId:(NSInteger)teacherId simple:(BOOL)simple;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end
