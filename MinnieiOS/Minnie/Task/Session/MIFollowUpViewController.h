//
//  MIFollowUpViewController.h
//  Minnie
//
//  Created by songzhen on 2019/8/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//  跟读任务   查看跟读

#import "IMManager.h"
#import "Homework.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIFollowUpViewController : UIViewController

// 查阅
@property (nonatomic,assign) BOOL isChecking;
@property (nonatomic,copy) NSString *audioUrl;

@property (nonatomic,strong) Homework *homework;

@property (nonatomic, strong) Teacher *teacher; // （管理端）

@property (nonatomic, strong) AVIMConversation *conversation;

@property (nonatomic, copy) void(^finishCallBack)(AVIMAudioMessage * _Nullable message);

@end

NS_ASSUME_NONNULL_END
