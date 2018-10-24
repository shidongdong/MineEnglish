//
//  ScheduleEditHeaderView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ScheduleEditHeaderView.h"
#import "UIColor+HEX.h"

@interface ScheduleEditHeaderView()

@property (nonatomic, weak) IBOutlet UIButton *startTimeButton;
@property (nonatomic, weak) IBOutlet UIButton *endTimeButton;
@property (nonatomic, weak) IBOutlet UIButton *weekendButton;
@property (nonatomic, weak) IBOutlet UIButton *workdayButton;

@end

@implementation ScheduleEditHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.startTimeButton.layer.cornerRadius = 12.f;
    self.startTimeButton.layer.masksToBounds = YES;
    [self.startTimeButton setBackgroundColor:[UIColor colorWithHex:0xF5F5F5]];
    
    self.endTimeButton.layer.cornerRadius = 12.f;
    self.endTimeButton.layer.masksToBounds = YES;
    [self.startTimeButton setBackgroundColor:[UIColor colorWithHex:0xF5F5F5]];
    
    self.weekendButton.layer.cornerRadius = 12.f;
    self.weekendButton.layer.masksToBounds = YES;
    self.weekendButton.layer.borderColor = [UIColor colorWithHex:0x979797].CGColor;
    self.weekendButton.layer.borderWidth = 0.5;
    [self.weekendButton setBackgroundColor:[UIColor whiteColor]];
    [self.weekendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.weekendButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    
    self.workdayButton.layer.cornerRadius = 12.f;
    self.workdayButton.layer.masksToBounds = YES;
    self.workdayButton.layer.borderColor = [UIColor colorWithHex:0x979797].CGColor;
    self.workdayButton.layer.borderWidth = 0.5;
    [self.workdayButton setBackgroundColor:[UIColor whiteColor]];
    [self.workdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.workdayButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
}

- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    
    [self.startTimeButton setTitle:[[self class] formatedDateString:_startDate] forState:UIControlStateNormal];
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    
    [self.endTimeButton setTitle:[[self class] formatedDateString:_endDate] forState:UIControlStateNormal];
}

- (void)setIsWeekend:(BOOL)isWeekend {
    _isWeekend = isWeekend;
    
    self.weekendButton.enabled = !isWeekend;
    if (isWeekend) {
        self.weekendButton.layer.borderWidth = 0;
        [self.weekendButton setBackgroundColor:[UIColor colorWithHex:0x00CE00]];
    } else {
        self.weekendButton.layer.borderWidth = 0.5;
        [self.weekendButton setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setIsWorkday:(BOOL)isWorkday {
    _isWorkday = isWorkday;
    
    self.workdayButton.enabled = !isWorkday;
    if (isWorkday) {
        self.workdayButton.layer.borderWidth = 0;
        [self.workdayButton setBackgroundColor:[UIColor colorWithHex:0x00CE00]];
    } else {
        self.workdayButton.layer.borderWidth = 0.5;
        [self.workdayButton setBackgroundColor:[UIColor whiteColor]];
    }
}

- (IBAction)startTimeButtonPressed:(id)sender {
    if (self.startDateCallback != nil) {
        self.startDateCallback();
    }
}

- (IBAction)endTimeButtonPressed:(id)sender {
    if (self.endDateCallback != nil) {
        self.endDateCallback();
    }
}

- (IBAction)weekendButtonPressed:(id)sender {
    if (self.weekendCallback != nil) {
        self.weekendCallback();
    }
}

- (IBAction)workdayButtonPressed:(id)sender {
    if (self.workdayCallback != nil) {
        self.workdayCallback();
    }
}

+ (NSString *)formatedDateString:(NSDate *)date {
    if (date == nil) {
        return nil;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    return [dateFormatter stringFromDate:date];
}

@end

