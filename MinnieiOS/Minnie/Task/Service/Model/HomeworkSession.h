//
//  HomeworkSession.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "Homework.h"
#import "Teacher.h"

@interface HomeworkSession : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger homeworkSessionId;
@property (nonatomic, strong) User *student;
@property (nonatomic, strong) Homework *homework;

@property (nonatomic, strong) Teacher *correctTeacher; // 批改作业的老师

@property (nonatomic, assign) long long sendTime; // 布置的时间
@property (nonatomic, assign) long long updateTime; // 更新的时间

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *reviewText;

@property (nonatomic, copy) NSString *lastSessionContent;
@property (nonatomic, assign) BOOL shouldColorLastSessionContent;
@property (nonatomic, assign) NSInteger unreadMessageCount; //用来存储未读条数 不属于网络请求返回
@property (nonatomic, strong) AVIMConversation *conversation;

@property (nonatomic, assign) CGFloat cellHeightWithoutMessage; // UI设置
@property (nonatomic, assign) CGFloat cellHeightWithMessage; // UI设置

@property (nonatomic, assign) long long sortTime; // 用来排序的
@property (nonatomic, assign) NSInteger isRedo; //重做
@property (nonatomic, copy) NSString * rankByDay;  //xx日第几次作业
/*
 标注的图形
 0：无
 1：闪电图形
 2：云朵图形
 3：消息图形
 */
@property (nonatomic, assign) NSInteger stuLabel;

@end


