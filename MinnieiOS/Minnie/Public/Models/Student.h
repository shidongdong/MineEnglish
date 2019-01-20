//
//  Student.h
//  X5
//
//  Created by yebw on 2018/4/6.
//  Copyright © 2018年 mfox. All rights reserved.
//

#import "User.h"
#import "Clazz.h"

@interface Student : User

@property (nonatomic, copy) NSString *grade; // 年级

@property (nonatomic, assign) NSUInteger starCount; // 剩余星星数
@property (nonatomic, assign) NSUInteger circleUpdate; // 朋友圈更新数

@property (nonatomic, strong) NSArray *homeworks; // 作业完成情况
@property (nonatomic, strong) Clazz *clazz; // 班级

@property (nonatomic, assign) NSInteger enrollState; // 报名状态

@property (nonatomic, assign) NSInteger warnCount;  //警告次数

@end
