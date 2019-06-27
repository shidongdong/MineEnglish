//
//  MICreateFolderView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureCallBack) (NSString * _Nullable name);
typedef void(^CancelCallBack) (void);

NS_ASSUME_NONNULL_BEGIN

@interface MICreateFolderView : UIView

@property (nonatomic, copy) SureCallBack sureCallBack;

@property (nonatomic, copy) CancelCallBack cancelCallBack;

// 创建、编辑文件夹
- (void)setupCreateFile:(NSString *)title fileName:(NSString *_Nullable)fileName;

// 删除文件夹
- (void)setupDeleteFile:(NSString *)fileName;

// 文件夹删除失败
- (void)setupDeleteError:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
