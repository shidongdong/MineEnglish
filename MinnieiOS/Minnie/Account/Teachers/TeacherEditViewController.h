//
//  TeacherEditViewController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//  教师信息

#import "BaseViewController.h"
#import "Teacher.h"

@interface TeacherEditViewController : BaseViewController

@property (nonatomic, strong) Teacher *teacher; // 有传值表示是编辑，否则是新建

@end
