//
//  MIReadingTaskViewController.h
//  Minnie
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "IMManager.h"
#import "Homework.h"
#import <UIKit/UIKit.h>

typedef void(^MIReadingTaskFinishCallBack)(AVIMAudioMessage * _Nullable message);

NS_ASSUME_NONNULL_BEGIN

@interface MIReadingTaskViewController : UIViewController

@property (nonatomic,strong) Homework *homework;

@property (nonatomic, strong) AVIMConversation *conversation;

@property (nonatomic, copy) MIReadingTaskFinishCallBack finishCallBack;

@end

NS_ASSUME_NONNULL_END
