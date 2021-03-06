//
//  CircleViewController.h
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"
#import "CircleService.h"

@interface CircleViewController : BaseViewController

// 指定同学圈的范围(学校0，还是班级1)
@property (nonatomic, assign) CircleType circleType;

// 指定某个具体的用户
@property (nonatomic, assign) NSInteger userId;

// 指定某个具体的班级
@property (nonatomic, assign) NSInteger classId;

@end
