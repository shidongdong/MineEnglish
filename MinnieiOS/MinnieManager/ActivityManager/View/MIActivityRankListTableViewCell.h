//
//  MIActivityRankListTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

extern CGFloat const MIActivityRankListTableViewCellHeight;

extern NSString * _Nullable const MIActivityRankListTableViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MIActivityRankListTableViewCell : UITableViewCell

- (void)setupWithModel:(ActivityRankInfo *)model index:(NSInteger)index;

- (void)setSelectedState:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
