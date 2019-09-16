//
//  MISutActDetailTableViewCell.h
//  MinnieStudent
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

extern CGFloat const MISutActDetailTableViewCellHeight;

extern NSString * _Nullable const MISutActDetailTableViewCellId;

typedef void(^MISutActDetailTableViewCellVideoCallback)(NSString *_Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface MISutActDetailTableViewCell : UITableViewCell


@property (nonatomic, copy) MISutActDetailTableViewCellVideoCallback videoCallback;

// 活动排行
- (void)setupRanInfo:(ActivityRankInfo *)rankInfo index:(NSInteger)index;

// 我的上传
- (void)setupRanInfo:(ActLogsInfo *)logsInfo;

@end

NS_ASSUME_NONNULL_END
