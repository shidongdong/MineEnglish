//
//  NSDate+Chat.m
//  YYTextDemo
//
//  Created by yebw on 2017/10/26.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "NSDate+X5.h"

@implementation NSDate(X5)

+ (NSDate *)todayZeroClock {
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:now];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    
    return [cal dateByAddingComponents:components toDate:now options:0];
}

- (BOOL)isToday {
    return [self isSameDayWithDate:[NSDate date]];
}

- (BOOL)isYesterday {
    return [self isSameDayWithDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]];
}

- (BOOL)isSameDayWithDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    
    return ([components1 day]==[components2 day] &&
            [components1 month]==[components2 month] &&
            [components1 year]==[components2 year]);
}

- (BOOL)isSameMonthWithDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:date];
    
    return ([components1 month]==[components2 month] && [components1 year]==[components2 year]);
}

- (BOOL)isSameYearWithDate:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    
    return [components1 year]==[components2 year];
}

- (BOOL)inAWeek {
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval start = [[NSDate todayZeroClock] timeIntervalSince1970] - 6 * 24 * 60 * 60;
    
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    return timeInterval >= start && timeInterval <= end;
}

- (NSString *)timeDescription {
    NSTimeInterval todayTimeInterval = [[NSDate todayZeroClock] timeIntervalSince1970];
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday|NSCalendarUnitHour) fromDate:self];
    NSInteger hour = components.hour;
    NSString *meridiem = hour<12 ? @"上午" : @"下午";
    
    NSString *result = @"";
    if (timeInterval > todayTimeInterval) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@h:mm", meridiem]];
        result = [dateFormatter stringFromDate:self];
    } else if ([self isYesterday]) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"昨天 %@h:mm", meridiem]];
        result = [dateFormatter stringFromDate:self];
    } else if ([self inAWeek]){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:self];
        NSInteger index = components.weekday-1;
        static NSArray *weekdays = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            weekdays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        });
        
        [dateFormatter setDateFormat:@"h:mm"];
        result = [NSString stringWithFormat:@"%@ %@%@", weekdays[index], meridiem, [dateFormatter stringFromDate:self]];
    } else if ([self isSameYearWithDate:[NSDate date]]){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"M月d日 %@h:mm", meridiem]];
        result = [dateFormatter stringFromDate:self];
    } else {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"yyyy年M月d日 %@h:mm", meridiem]];
        result = [dateFormatter stringFromDate:self];
    }
    
    return result;
}

@end

