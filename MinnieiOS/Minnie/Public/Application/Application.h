//
//  Application.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Teacher.h"
#import "Student.h"

#ifndef APP
#define APP ([Application sharedInstance])



#endif

// 应用运行时的一些基本信息
@interface Application : NSObject

+ (instancetype)sharedInstance;

#if TEACHERSIDE
@property (nonatomic, strong) Teacher *currentUser;
#else
@property (nonatomic, strong) Student *currentUser;
#endif

@property (nonatomic, assign) NSInteger videoDownloadNetworkSetting; // -1：关闭，0开启，1仅Wifi下开启

@property (nonatomic, strong) NSString *lastLoginUsename;

@property (nonatomic, assign) NSInteger currentIMHomeworkSessionId;

@property (nonatomic, assign) NSInteger classIdAlertShown; // 已经显示弹框过的班级id

@property (nonatomic, strong) NSData * deviceToken;    //推送token

@property (nonatomic, strong) NSArray * unfinishHomeworkSessionList;  //未完成作业

@property (nonatomic, strong) NSArray * finishHomeworkSessionList;  //完成的作业

@property (nonatomic, strong) NSArray * unCommitHomeworkSessionList;  //未提交的作业

@property (nonatomic, strong) NSArray * circleList;  //朋友圈

- (void)clearData;

@end
