//
//  MIStudentWordsViewController.h
//  MinnieStudent
//
//  Created by songzhen on 2019/8/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "IMManager.h"
#import "Homework.h"
#import <UIKit/UIKit.h>
#import "MIReadingTaskViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MIStudentWordsViewController : UIViewController

// 查阅
@property (nonatomic,copy) NSString *audioUrl;

@property (nonatomic,strong) Homework *homework;

@property (nonatomic, strong) Teacher *teacher; // （管理端）

@property (nonatomic, strong) AVIMConversation *conversation;

@property (nonatomic, copy) MIReadingTaskFinishCallBack finishCallBack;

@end

NS_ASSUME_NONNULL_END
