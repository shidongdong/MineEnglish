//
//  MISubStockSplitViewController.h
//  Minnie
//
//  Created by songzhen on 2019/7/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MITaskListViewController.h"
#import "MIBaseDetailViewController.h"
#import "CSCustomSplitViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface MISubStockSplitViewController : CSCustomSplitViewController

@property (nonatomic, strong) MITaskListViewController *stockMasterVC;
@property (nonatomic, strong) MIBaseDetailViewController *stockDetailVC;

@property (nonatomic, copy) ActionAddFolderCallBack addFolderCallBack;

/*
 *  任务列表
 */

- (void)showTaskListWithFoldInfo:(FileInfo * _Nullable)fileInfo folderIndex:(NSInteger)folder;

// yes 添加文件夹 no 添加文件
- (void)showEmptyViewWithIsFolder:(BOOL)isAddFolder folderIndex:(NSInteger)folder;




@end

NS_ASSUME_NONNULL_END
