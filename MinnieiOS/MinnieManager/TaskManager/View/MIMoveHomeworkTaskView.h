//
//  MIMoveHomeworkTaskView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Homework.h"
#import "ParentFileInfo.h"

typedef void(^MoveHomeworkTaskSuccessCallback)(void);
typedef void(^MoveHomeworkTaskCancelCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MIMoveHomeworkTaskView : UIView

@property (nonatomic, copy) MoveHomeworkTaskSuccessCallback callback;
@property (nonatomic, copy) MoveHomeworkTaskCancelCallback cancelCallback;

// 两级路径
@property (nonatomic, assign) BOOL isMultiple;

@property (nonatomic, strong) FileInfo *currentFileInfo;
@property (nonatomic, strong) NSArray *homeworkIds;// 作业id

@end

NS_ASSUME_NONNULL_END
