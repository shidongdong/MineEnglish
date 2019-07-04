//
//  MITaskListViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//  任务列表

#import "ParentFileInfo.h"
#import "BaseViewController.h"


typedef void(^PushNewVCCallBack) (UIViewController * _Nullable VC);

// 新建任务 state 0：进入创建，1：创建成功 2：取消创建
typedef void(^CreateHomeworkTaskCallBack) (UIViewController * _Nullable VC,NSInteger createState);

typedef void(^ActionAddFolderCallBack) (NSInteger folderIndex);

#pragma mark - 


NS_ASSUME_NONNULL_BEGIN

@interface MITaskListViewController : BaseViewController


@property (nonatomic, strong) UIViewController *parentVC;

@property (nonatomic, copy) PushNewVCCallBack pushVCCallBack;

@property (nonatomic, copy) CreateHomeworkTaskCallBack createTaskCallBack;

@property (nonatomic, copy) ActionAddFolderCallBack addFolderCallBack;

- (void)showTaskListWithFoldInfo:(FileInfo * _Nullable)fileInfo folderIndex:(NSInteger)folder;

// yes 添加文件夹 no 添加文件
- (void)showEmptyViewWithIsFolder:(BOOL)isAddFolder folderIndex:(NSInteger)folder;


@end

NS_ASSUME_NONNULL_END
