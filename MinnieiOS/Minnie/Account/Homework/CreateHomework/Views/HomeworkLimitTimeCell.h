//
//  HomeworkLimitTimeCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/12.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeworkLimitTimeCellId;
extern CGFloat const HomeworkTimeLimitTableViewCellHeight;

typedef void(^HomeworkLimitTimeCellClickCallback)(void);

@interface HomeworkLimitTimeCell : UITableViewCell

@property (nonatomic, copy)HomeworkLimitTimeCellClickCallback timeCallback;

- (void)updateTimeLabel:(NSInteger)sec;

@end
