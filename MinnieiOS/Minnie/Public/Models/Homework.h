//
//  Homework.h
//  X5
//
//  Created by yebw on 2017/9/17.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>
#import "Teacher.h"
#import "HomeworkItem.h"
#import "HomeworkAnswerItem.h"

// 教师创建的作业
@interface Homework : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger homeworkId; // 作业id
@property (nonatomic, strong) Teacher *createTeacher; // 创建老师

@property (nonatomic, strong) NSString *title; // 标题
@property (nonatomic, strong) NSArray <HomeworkItem *>* items; // 作业内容项

@property (nonatomic, strong) NSArray <HomeworkAnswerItem *>* answerItems; // 作业内容项

@property (nonatomic, assign) long long createTime; // 创建的时间

@property (nonatomic, strong) NSArray <NSString *> *tags; // 标签

@property (nonatomic, assign) NSInteger style; //作业类型：日常1、假期2、集训3

@property (nonatomic, assign) NSInteger level; //作业难度，简单1，一般2，困难3

@property (nonatomic, assign) NSInteger category; //作业类型：普通1、附件2、初始化0

@property (nonatomic, assign) NSInteger limitTimes; //作业限制时长，单位秒

@property (nonatomic, strong) NSString * formTag;  //作业类型标签: 拼读，指读，默写，订正等等

// UI
@property (nonatomic, assign) CGFloat cellHeight;

- (NSDictionary *)dictionaryForUpload;

@end

