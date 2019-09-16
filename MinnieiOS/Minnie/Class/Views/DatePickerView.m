//
//  DatePickerView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "NSDate+X5.h"
#import "NSDate+Extension.h"
#import "DatePickerView.h"
#import <Masonry/Masonry.h>

@interface DatePickerView()

@property (nonatomic, copy) DatePickerViewCallback callback;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *defaultDate;

@end

@implementation DatePickerView


- (void)awakeFromNib {
    
    [super awakeFromNib];
}

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

+ (void)showInView:(UIView *)view
          dateTime:(NSDate *)dateTime
          callback:(DatePickerViewCallback)callback{
   
    DatePickerView *v = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:nil options:nil] lastObject];
    [v setPickerStyle];
    v.callback = callback;
    
    if (dateTime != nil) {
        v.defaultDate = dateTime;
    }
    
    [view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

- (void)setPickerStyle{
    
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];
}

- (void)showActionAnimated {
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    CATransform3D translate = CATransform3DMakeTranslation(0, ScreenHeight, 0); //平移
    self.datePicker.layer.transform = translate;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.datePicker.layer.transform = CATransform3DIdentity;
    } completion:nil];
}

- (void)hideActionAnimated {
    CATransform3D translate = CATransform3DMakeTranslation(0, ScreenHeight, 0); //平移
    self.datePicker.layer.transform = CATransform3DIdentity;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.datePicker.layer.transform = translate;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
