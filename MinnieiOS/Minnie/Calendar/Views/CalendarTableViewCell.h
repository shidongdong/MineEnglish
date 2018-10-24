//
//  CalendarTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/17.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayItem: NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger weakday;
@property (nonatomic, assign) BOOL isOtherMonth;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, assign) BOOL isClassDay;

@property (nonatomic, strong) NSDate *date;

@end

@interface MonthItem : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) NSMutableArray<DayItem *> *dayItems;

@end

typedef void(^CalendarTableViewCellValueDidChangeCallback)(NSInteger);

extern NSString * const CalendarTableViewCellId;

@interface CalendarTableViewCell : UITableViewCell

@property (nonatomic, copy) CalendarTableViewCellValueDidChangeCallback callback;

- (void)updateWithMonthItem:(MonthItem *)monthItem editMode:(BOOL)isEditMode;

@end
