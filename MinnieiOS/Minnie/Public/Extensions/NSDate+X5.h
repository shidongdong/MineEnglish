//
//  NSDate+Chat.h
//  YYTextDemo
//
//  Created by yebw on 2017/10/26.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(X5)

- (BOOL)isToday;

- (BOOL)isYesterday;

- (BOOL)isSameDayWithDate:(NSDate *)date;

- (BOOL)isSameMonthWithDate:(NSDate *)date;

- (BOOL)isSameYearWithDate:(NSDate *)date;

- (BOOL)inAWeek;

- (NSString *)timeDescription;

@end

