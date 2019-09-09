//
//  MITaskListViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//  任务列表

#import "ParentFileInfo.h"
#import "BaseViewController.h"



#pragma mark - 


NS_ASSUME_NONNULL_BEGIN

@interface MITaskListViewController : BaseViewController

@property (nonatomic, copy) void(^pushVCCallBack) (UIViewController * _Nullable VC);

// 新建任务 state 0：进入创建，1：创建成功 2：取消创建
@property (nonatomic, copy) void(^createTaskCallBack) (UIViewController * _Nullable VC,NSInteger createState);

@property (nonatomic, copy) void(^addFolderCallBack) (NSInteger folderIndex);

- (void)showTaskListWithFoldInfo:(FileInfo * _Nullable)fileInfo folderIndex:(NSInteger)folder;

// yes 添加文件夹 no 添加文件
- (void)showEmptyViewWithIsFolder:(BOOL)isAddFolder folderIndex:(NSInteger)folder;

- (void)resetSelectIndex;

@end

NS_ASSUME_NONNULL_END
