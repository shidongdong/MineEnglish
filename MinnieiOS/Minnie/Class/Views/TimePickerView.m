//
//  TimePickerView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "TimePickerView.h"
#import <Masonry/Masonry.h>

@interface TimePickerView()

@property (nonatomic, copy) TimePickerViewCallback callback;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation TimePickerView

+ (void)showInView:(UIView *)view
              date:(NSString *)date
          callback:(TimePickerViewCallback)callback {
    TimePickerView *v = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:nil options:nil] lastObject];

    v.callback = callback;
    
    if ([date containsString:@":"]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitWeekday) fromDate:[NSDate date]];
        components.hour = [[date componentsSeparatedByString:@":"][0] integerValue];
        components.minute = [[date componentsSeparatedByString:@":"][1] integerValue];
        
        v.datePicker.date = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmButtonPressed:(id)sender {
    NSDate *date = self.datePicker.date;
    NSString *time = [[self class] formatedDateString:date];

    if (self.callback != nil) {
        self.callback(time);
    }

    [self removeFromSuperview];
}

+ (NSString *)formatedDateString:(NSDate *)date {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"H:mm"];
    return [dateFormatter stringFromDate:date];
}

@end
