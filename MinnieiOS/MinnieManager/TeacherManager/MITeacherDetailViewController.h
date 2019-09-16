//
//  MITeacherDetailViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//  教师详情

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TeacherDetailPushCallBack)(UIViewController *vc);

@interface MITeacherDetailViewController : UIViewController

@property (nonatomic, copy) TeacherDetailPushCallBack pushCallBack;
// 编辑教师
@property (nonatomic, copy) void (^editSuccessCallBack) (BOOL isDelete);

- (void)updateTeacher:(Teacher * _Nullable)teacher;

- (void)resetCurrentSelectIndex;


@end

NS_ASSUME_NONNULL_END
