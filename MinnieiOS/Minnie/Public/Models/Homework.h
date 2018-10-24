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

// UI
@property (nonatomic, assign) CGFloat cellHeight;

- (NSDictionary *)dictionaryForUpload;

@end

