//
//  MITaskListViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//  任务列表

#import "ParentFileInfo.h"
#import "BaseViewController.h"

typedef void(^ActionAddFolderCallBack) (NSInteger folderIndex);

NS_ASSUME_NONNULL_BEGIN

@interface MITaskListViewController : BaseViewController

@property (nonatomic, copy) ActionAddFolderCallBack addFolderCallBack;

@property (nonatomic, copy) NSString *folderTitle;

- (void)showTaskListWithFoldInfo:(FileInfo * _Nullable)fileInfo folderIndex:(NSInteger)folder;

// yes 添加文件夹 no 添加文件
- (void)showEmptyViewWithIsFolder:(BOOL)isAddFolder folderIndex:(NSInteger)folder;

@end

NS_ASSUME_NONNULL_END
