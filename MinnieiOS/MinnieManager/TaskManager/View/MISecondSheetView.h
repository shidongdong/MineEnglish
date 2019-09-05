//
//  SecondSheetView.h
//  Manager
//
//  Created by songzhen on 2019/5/27.
//  Copyright © 2019 songzhen. All rights reserved.
//  任务管理文件夹

#import <UIKit/UIKit.h>
#import "ParentFileInfo.h"

@protocol SecondSheetViewDelegate <NSObject>

@optional

// 查看发送记录
- (void)toSendRecord;

- (void)toSearchHomework;


// 点击任务管理一级文件夹
- (void)secondSheetViewFirstLevelData:(ParentFileInfo *_Nullable)data index:(NSInteger)index;

// 点击任务管理二级文件夹
- (void)secondSheetViewSecondLevelData:(FileInfo *_Nullable)data index:(NSInteger)index;

// 删除文件夹
- (void)secondSheetViewDeleteFile;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MISecondSheetView : UIView


@property (nonatomic, weak) id<SecondSheetViewDelegate> delegate;

- (void)updateFileListInfo;

- (void)collapseAllFolders;

// 新建二级文件夹
- (void)addSecondLevelFolderIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
