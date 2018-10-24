//
//  ScheduleEditHeaderView.h
//  X5Teacher
//
//  Created by yebw on 2018/1/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScheduleEditHeaderViewStartDateCallback)(void);
typedef void(^ScheduleEditHeaderViewEndDateCallback)(void);

typedef void(^ScheduleEditHeaderViewWeekendCallback)(void);
typedef void(^ScheduleEditHeaderViewWorkdayCallback)(void);

@interface ScheduleEditHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) BOOL isWeekend;
@property (nonatomic, assign) BOOL isWorkday;

@property (nonatomic, copy) ScheduleEditHeaderViewStartDateCallback startDateCallback;
@property (nonatomic, copy) ScheduleEditHeaderViewEndDateCallback endDateCallback;
@property (nonatomic, copy) ScheduleEditHeaderViewWeekendCallback weekendCallback;
@property (nonatomic, copy) ScheduleEditHeaderViewWorkdayCallback workdayCallback;

@end
