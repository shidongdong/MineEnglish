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

@interface MIScoreListViewController : UIViewController

@property (nonatomic, strong) Homework *homework;
@property (nonatomic, strong) FileInfo *currentFileInfo;

@property (nonatomic, assign) BOOL teacherSider;

@property (nonatomic, copy) MIScoreEditTaskCallBack callBack;

@end

NS_ASSUME_NONNULL_END
