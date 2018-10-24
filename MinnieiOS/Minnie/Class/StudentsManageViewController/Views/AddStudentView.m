//
//  AddStudentView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "AddStudentView.h"
#import <Masonry/Masonry.h>
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddStudentView()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIView *phoneNumberView;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberTextField;
@property (nonatomic, weak) IBOutlet UIView *nameView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;

@property (nonatomic, copy) ConfirmAddStudentClickCallback confirmCallback;

@end

@implementation AddStudentView

+ (instancetype)sharedInstance {
    static AddStudentView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AddStudentView class]) owner:nil options:nil] lastObject];
    });
    
    return instance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.confirmButton.backgroundColor = nil;
    self.confirmButton.layer.cornerRadius = 12.f;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x0098FE]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x0098FE alpha:0.8]] forState:UIControlStateHighlighted];
    
    self.phoneNumberView.layer.cornerRadius = 12.f;
    self.phoneNumberView.layer.masksToBounds = YES;
    self.phoneNumberView.layer.borderWidth = 0.5;
    self.phoneNumberView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    
    self.nameView.layer.cornerRadius = 12.f;
    self.nameView.layer.masksToBounds = YES;
    self.nameView.layer.borderWidth = 0.5;
    self.nameView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    
    self.cancelButton.layer.cornerRadius = 12.f;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = 0.5;
    self.cancelButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    
    self.contentView.layer.cornerRadius = 12.f;
    self.contentView.layer.shadowOpacity = 0.15;// 阴影透明度
    self.contentView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.f].CGColor;
    self.contentView.layer.shadowRadius = 3;
    self.contentView.layer.shadowOffset = CGSizeMake(2, 4);
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)showInSuperView:(UIView *)superView
               callback:(ConfirmAddStudentClickCallback)callback {
    AddStudentView *view = [AddStudentView sharedInstance];
    if (view.superview != nil) {
        [view removeFromSuperview];
    }
    
    view.phoneNumberTextField.text = nil;
    view.nameTextField.text = nil;
    view.confirmCallback = callback;
    
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    [view showWithAnimation];
}

- (void)showWithAnimation {
    self.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .3f;
        scaleAnimation.values = @[@0, @1];
        scaleAnimation.keyTimes = @[@0, @.3];
        scaleAnimation.repeatCount = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        self.backgroundView.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1.f;
        } completion:^(BOOL finished) {
            [self.phoneNumberTextField becomeFirstResponder];
        }];
    });
}

+ (void)hideAnimated:(BOOL)animated {
    AddStudentView *studentView = [AddStudentView sharedInstance];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .3f;
        scaleAnimation.values = @[@1, @0];
        scaleAnimation.keyTimes = @[@0, @.3];
        scaleAnimation.repeatCount = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [studentView.contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        studentView.backgroundView.alpha = 1.f;
        [UIView animateWithDuration:0.3 animations:^{
            studentView.backgroundView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [studentView removeFromSuperview];
        }];
    });
}

- (IBAction)cancelButtonPressed:(id)sender {
    [[self class] hideAnimated:YES];
}

- (IBAction)confirmButtonPressed:(id)sender {
    NSString *phoneNumber = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (phoneNumber.length == 0) {
        [HUD showErrorWithMessage:@"请输入电话号码"];
        return;
    }

    if (self.confirmCallback != nil) {
        self.confirmCallback(phoneNumber);
    }
}

@end


