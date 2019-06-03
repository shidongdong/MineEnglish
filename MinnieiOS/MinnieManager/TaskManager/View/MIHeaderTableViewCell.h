//
//  HeaderTableViewCell.h
//  Manager
//
//  Created by songzhen on 2019/5/27.
//  Copyright © 2019 songzhen. All rights reserved.
//  文件夹cell

#import <UIKit/UIKit.h>
#import "MIFirLevelFolderModel.h"

extern NSString * _Nullable const MIHeaderTableViewCellId;

extern CGFloat const MIHeaderTableViewCellHeight;


@protocol HeaderViewDelegate <NSObject>

@optional

// 添加一级文件夹
- (void)headerViewAddClicked:(NSInteger)index;

- (void)headerViewDidCellClicked:(NSIndexPath *_Nullable)indexPath isParentFile:(BOOL)isParentFile;

- (void)headerViewEditFileClicked:(NSIndexPath *_Nullable)indexPath isParentFile:(BOOL)isParentFile;

@end


NS_ASSUME_NONNULL_BEGIN

@interface MIHeaderTableViewCell : UITableViewCell


@property (nonatomic , assign) id<HeaderViewDelegate> delegate;

- (void)setupFilesWithFileInfo:(FileInfo *)fileInfo indexPath:(NSIndexPath *)indexPath isParentFile:(NSInteger)isParentFile selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
