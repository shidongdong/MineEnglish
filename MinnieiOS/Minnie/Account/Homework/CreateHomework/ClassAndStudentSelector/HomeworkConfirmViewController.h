//
//  HomeworkConfirmViewController.h
//  MinnieTeacher
//
//  Created by songzhen on 2019/4/30.
//  Copyright © 2019 minnieedu. All rights reserved.
// 发送确认

#import "BaseViewController.h"

//typedef void(^Success)(BOOL sendSuccess);

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkConfirmViewController : BaseViewController

// 要发送的作业
@property (nonatomic, strong) NSArray *homeworks;

// 接收作业的班级
@property (nonatomic, strong) NSArray *classes;

// 接收作业的学生
@property (nonatomic, strong) NSArray *students;

// 负责此次作业的老师
@property (nonatomic, strong) Teacher *teacher;

@property (nonatomic, strong) NSDate *dateTime;

//@property (nonatomic,copy) Success sendSuccessBlock;

@end

NS_ASSUME_NONNULL_END
