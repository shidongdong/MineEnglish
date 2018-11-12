//
//  ChooseDatePickerView.m
//  MotherPlanet
//
//  Created by Coder on 2018/6/4.
//  Copyright © 2018年 Geek Zoo Studio. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenRect [UIScreen mainScreen].bounds

#import "ChooseDatePickerView.h"

@interface ChooseDatePickerView ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSInteger minIndex;
    NSInteger secIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;

@property (nonatomic, strong) NSDateComponents *comp;
@property (nonatomic, strong) NSMutableArray * minArray;
@property (nonatomic, strong) NSMutableArray * secArray;

@end

@implementation ChooseDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ChooseDatePickerView" owner:self options:nil].lastObject;
    } return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addMinAndSecLabel];
}

- (void)setDefultSeconds:(NSInteger)secs
{
    secIndex = secs % 60;
    minIndex = secs / 60;
    
    [self selectActionToPickerView:self.datePicker row:minIndex inComponent:0];
    [self selectActionToPickerView:self.datePicker row:secIndex inComponent:1];
    
}


- (void)addMinAndSecLabel
{
    CGFloat pointX = ([UIScreen mainScreen].bounds.size.width - 180) / 2 + 65;
    
    UILabel * minLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointX, self.basicView.frame.size.height/2-15/2.0 + 26, 15, 15)];
    minLabel.text = @"分";
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.font = [UIFont systemFontOfSize:14];
    minLabel.textColor =  [UIColor blackColor];
    minLabel.backgroundColor = [UIColor clearColor];
    [self.basicView addSubview:minLabel];
    
    pointX = ([UIScreen mainScreen].bounds.size.width - 180) / 2 + 90 + 65;
    
    UILabel * secLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointX, self.basicView.frame.size.height/2-15/2.0 + 26, 15, 15)];
    secLabel.text = @"秒";
    secLabel.textAlignment = NSTextAlignmentCenter;
    secLabel.font = [UIFont systemFontOfSize:14];
    secLabel.textColor =  [UIColor blackColor];
    secLabel.backgroundColor = [UIColor clearColor];
    [self.basicView addSubview:secLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

#pragma mark - Date Data


- (NSMutableArray *)minArray {
    if (_minArray == nil) {
        _minArray = [NSMutableArray array];
        for (int min = 0; min <= 5; min++) {
            NSString *str = [NSString stringWithFormat:@"%d", min];
            [_minArray addObject:str];
        }
    }
    return _minArray;
}

- (NSMutableArray *)secArray {
    if (_secArray == nil) {
        _secArray = [NSMutableArray array];
        for (int sec = 0; sec <= 59; sec++) {
            NSString *str = [NSString stringWithFormat:@"%02d", sec];
            [_secArray addObject:str];
        }
    }
    return _secArray;
}

#pragma mark UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.minArray.count;
    } else {
        return self.secArray.count;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 49;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return 90;
}

#pragma mark - UIPickerView Delegate

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        minIndex = row;
        if (minIndex == 5 && secIndex != 0)
        {
            [self selectActionToPickerView:pickerView row:0 inComponent:1];
        }
    }
    else
    {
        secIndex = row;
        
        if (minIndex == 5 && secIndex != 0)
        {
            [self selectActionToPickerView:pickerView row:0 inComponent:1];
        }
        
    }
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        genderLabel.text = self.minArray[row];
    }else {
        genderLabel.text = self.secArray[row];
    }
    return genderLabel;
}

- (void)selectActionToPickerView:(UIPickerView *)pickerView row:(NSInteger)row inComponent:(NSInteger)inComponent {
    [pickerView selectRow:row inComponent:inComponent animated:YES];
    [self pickerView:pickerView didSelectRow:row inComponent:inComponent];
}



#pragma mark - Animated

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self showActionAnimated];
}

- (void)hide {
    [self hideActionAnimated];
}

- (void)showActionAnimated {
    CATransform3D translate = CATransform3DMakeTranslation(0, kScreenHeight, 0); //平移
    self.basicView.layer.transform = translate;
    self.backButton.alpha = 0;
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.backButton.alpha = 0.5;
        self.basicView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideActionAnimated {
    CATransform3D translate = CATransform3DMakeTranslation(0, kScreenHeight, 0); //平移
    self.basicView.layer.transform = CATransform3DIdentity;
    self.backButton.alpha = 0.5;
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.backButton.alpha = 0;
        self.basicView.layer.transform = translate;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Action

- (IBAction)cancelAction:(UIButton *)sender {
    [self hide];
}

- (IBAction)confirmAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(finishSelectDate:)]) {
        [self.delegate finishSelectDate:minIndex * 60 + secIndex];
    }
    
    [self hide];
}

@end
