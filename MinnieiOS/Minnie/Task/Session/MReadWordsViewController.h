//
//  MIStudentWordsViewController.h
//  MinnieStudent
//
//  Created by songzhen on 2019/8/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//  单词任务

#import "IMManager.h"
#import "Homework.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MReadWordsViewController : UIViewController

// 查阅
@property (nonatomic,copy) NSString *audioUrl;

@property (nonatomic,strong) Homework *homework;

@property (nonatomic, strong) Teacher *teacher; // （管理端）

@property (nonatomic, strong) AVIMConversation *conversation;

@property (nonatomic, copy) void(^finishCallBack)(AVIMAudioMessage * _Nullable message) ;

@end

NS_ASSUME_NONNULL_END
