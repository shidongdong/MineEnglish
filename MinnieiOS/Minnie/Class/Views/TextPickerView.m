//
//  TimePickerView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "TextPickerView.h"
#import <Masonry/Masonry.h>

@interface TextPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy) NSArray *contents;
@property (nonatomic, copy) TextPickerViewCallback callback;
@property (nonatomic, weak) IBOutlet UIPickerView *picker;
@property (nonatomic, assign) NSInteger index;

@end

@implementation TextPickerView

+ (void)showInView:(UIView *)view
          contents:(NSArray<NSString *> *)contents
     selectedIndex:(NSInteger)index
          callback:(TextPickerViewCallback)callback {
    TextPickerView *v = [[[NSBundle mainBundle] loadNibNamed:@"TextPickerView" owner:nil options:nil] lastObject];
    
    v.contents = contents;
    v.index = index;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [v.picker selectRow:index inComponent:0 animated:NO];
    });
    
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
    if (self.callback != nil) {
        self.callback(self.contents[self.index]);
    }

    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.contents.count;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.contents[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    self.index = row;
}

@end
