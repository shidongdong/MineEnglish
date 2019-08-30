//
//  MIScoreListViewController.h
//  
//
//  Created by songzhen on 2019/5/31.
//

#import "Homework.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MIScoreEditTaskCallBack)(void);
typedef void(^MIScoreListCancelCallBack)(void);

@interface MIScoreListViewController : UIViewController

@property (nonatomic, strong) Homework *homework;
@property (nonatomic, strong) FileInfo *currentFileInfo;

@property (nonatomic, assign) BOOL teacherSider;
@property (nonatomic, assign) Teacher *teacher;

// 是否隐藏编辑任务
@property (nonatomic, assign) BOOL hiddenEditTask;

@property (nonatomic, copy) MIScoreEditTaskCallBack editTaskCallBack;
@property (nonatomic, copy) MIScoreListCancelCallBack cancelCallBack;

@end

NS_ASSUME_NONNULL_END
