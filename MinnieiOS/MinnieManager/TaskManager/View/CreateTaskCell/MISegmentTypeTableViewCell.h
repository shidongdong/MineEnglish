//
//  MISegmentTypeTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//  分段选择类型

#import <UIKit/UIKit.h>

extern CGFloat const MISegmentTypeTableViewCellHeight;

extern NSString * _Nullable const MISegmentTypeTableViewCellId;

typedef void(^SegmentCallback)(NSInteger selectIndex);

NS_ASSUME_NONNULL_BEGIN

@interface MISegmentTypeTableViewCell : UITableViewCell

@property (nonatomic, copy) SegmentCallback callback;

- (void)setupWithSelectIndex:(NSInteger)index
                  createType:(MIHomeworkCreateContentType)createType;

@end

NS_ASSUME_NONNULL_END
