//
//  DatePickerView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "DatePickerView.h"
#import <Masonry/Masonry.h>

@interface DatePickerView()

@property (nonatomic, copy) DatePickerViewCallback callback;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *defaultDate;

@end

@implementation DatePickerView

+ (void)showInView:(UIView *)view
              date:(NSDate *)date
          callback:(DatePickerViewCallback)callback {
    DatePickerView *v = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:nil options:nil] lastObject];

    v.callback = callback;
    
    if (date != nil) {
        v.defaultDate = date;
    }

    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

- (void)setDefaultDate:(NSDate *)defaultDate {
    self.datePicker.date = defaultDate;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmButtonPressed:(id)sender {
    NSDate *date = self.datePicker.date;
    if (self.callback != nil) {
        self.callback(date);
    }

    [self removeFromSuperview];
}

@end
