//
//  StudentStarRecordViewController.h
//  MinnieStudent
//
//  Created by songzhen on 2019/4/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentStarRecordViewController : BaseViewController

// 0 星星记录 1 礼物兑换 2 任务得分 3 考试统计
@property (nonatomic, assign) NSInteger recordType;

- (void)updateStarRecord;

@end

NS_ASSUME_NONNULL_END
