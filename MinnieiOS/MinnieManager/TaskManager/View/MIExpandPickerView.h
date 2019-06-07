//
//  MIExpandPickerView.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentFileInfo.h"

typedef void(^ExpandPickerViewCallback)(NSString *_Nonnull);

typedef void(^ExpandPickerLocalCallback)(id _Nonnull);

NS_ASSUME_NONNULL_BEGIN

@interface MIExpandPickerView : UIView

@property (nonatomic, copy) ExpandPickerViewCallback callback;
@property (nonatomic, copy) ExpandPickerLocalCallback localCallback;

- (void)show;

- (void)hide;

// 时间选择
- (void)setDefultText:(NSString *)text createType:(MIHomeworkCreateContentType)createType;

// 子文件夹位置选择
- (void)setDefultFileInfo:(FileInfo *)fileInfo fileArray:(NSArray<ParentFileInfo*>*)fileArray;
// 父文件夹位置选择
- (void)setDefultParentFileInfo:(FileInfo *)fileInfo fileArray:(NSArray<ParentFileInfo*>*)fileArray;
@end

NS_ASSUME_NONNULL_END
