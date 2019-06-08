//
//  MIInPutTypeTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//  title + 输入类型

#import <UIKit/UIKit.h>

extern NSString * _Nullable const MIInPutTypeTableViewCellId;

typedef void(^InputHeightCallback)(NSString * _Nullable text, BOOL heightChanged);

NS_ASSUME_NONNULL_BEGIN

@interface MIInPutTypeTableViewCell : UITableViewCell

@property (nonatomic, copy) InputHeightCallback callback;

- (void)setupWithText:(NSString *)text
                title:(NSString *)title
           createType:(MIHomeworkCreateContentType)createType
          placeholder:(NSString *)holder;

+ (CGFloat)cellHeightWithText:(NSString *)text cellWidth:(CGFloat)cellWidth;

- (void)ajustTextView;

@end

NS_ASSUME_NONNULL_END
