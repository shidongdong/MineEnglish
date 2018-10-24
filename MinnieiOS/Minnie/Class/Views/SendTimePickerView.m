//
//  TimePickerView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "SendTimePickerView.h"
#import <Masonry/Masonry.h>

@interface SendTimePickerView()

@property (nonatomic, copy) SendTimePickerViewCallback callback;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation SendTimePickerView

+ (void)showInView:(UIView *)view
          callback:(SendTimePickerViewCallback)callback {
    SendTimePickerView *v = [[[NSBundle mainBundle] loadNibNamed:@"SendTimePickerView" owner:nil options:nil] lastObject];

    v.datePicker.minimumDate = [NSDate date];
    v.callback = callback;

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

    if (self.callback != nil) {
        self.callback(date);
    }

    [self removeFromSuperview];
}

@end
