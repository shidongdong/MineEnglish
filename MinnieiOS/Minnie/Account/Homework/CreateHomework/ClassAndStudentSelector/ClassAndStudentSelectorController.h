//
//  ClassAndStudentSelectorController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clazz.h"
#import "Homework.h"

#import "NoticeMessage.h"

// 这个代理只有在发送消息的时候使用，发送作业的功能直接继承在这个vc里面了； ：（
@protocol ClassAndStudentSelectorControllerDelegate<NSObject>

- (void)classesDidSelect:(NSArray<Clazz *> *)classes;

- (void)studentsDidSelect:(NSArray<User *> *)students;

@end

// 发送消息、发送作业、创建活动
@interface ClassAndStudentSelectorController : UIViewController

@property (nonatomic, weak) IBOutlet id<ClassAndStudentSelectorControllerDelegate> delegate;

// 要发送的作业
@property (nonatomic, strong) NSArray <Homework *> *homeworks;

//  创建活动
@property (nonatomic, assign) BOOL isCreateActivityTask;

@end
