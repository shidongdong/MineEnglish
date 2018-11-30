//
//  ExchangeAwardView.m
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "DeleteTeacherAlertView.h"
#import <Masonry/Masonry.h>
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DeleteTeacherAlertView()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) SendDeleteTeacherCodeClickCallback sendCodeCallback;
@property (nonatomic, copy) ConfirmDeleteClickCallback confirmCallback;

@end

@implementation DeleteTeacherAlertView

+ (instancetype)sharedInstance {
    static DeleteTeacherAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DeleteTeacherAlertView class]) owner:nil options:nil] lastObject];
    });
    
    return instance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sendButton.backgroundColor = nil;
    self.sendButton.layer.cornerRadius = 12.f;
    self.sendButton.layer.masksToBounds = YES;
    [self.sendButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x00CE00]] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x00CE00 alpha:0.8]] forState:UIControlStateHighlighted];
    [self.sendButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0xDDDDDD]] forState:UIControlStateDisabled];
    
    self.deleteButton.backgroundColor = nil;
    self.deleteButton.layer.cornerRadius = 12.f;
    self.deleteButton.layer.masksToBounds = YES;
    [self.deleteButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0xFF4858]] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0xFF4858 alpha:0.8]] forState:UIControlStateHighlighted];
    
    self.cancelButton.layer.cornerRadius = 12.f;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = 0.5;
    self.cancelButton.layer.borderColor = [UIColor colorWithHex:0xFF4858].CGColor;
    
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

+ (void)showDeleteTeacherAlertView:(UIView *)superView
                           teacher:(Teacher *)teacher
                  sendCodeCallback:(SendDeleteTeacherCodeClickCallback)sendCodeCallback
                   confirmCallback:(ConfirmDeleteClickCallback)confirmCallback {
    DeleteTeacherAlertView *view = [DeleteTeacherAlertView sharedInstance];
    if (view.superview != nil) {
        [view.timer invalidate];
        view.timer = nil;
        [view removeFromSuperview];
    }
    
    view.sendButton.enabled = YES;
    [view.sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    
    view.deleteButton.enabled = NO;
    
//    view.codeTextField.enabled = NO;
    
    view.codeTextField.text = nil;
    
    view.sendCodeCallback = sendCodeCallback;
    view.confirmCallback = confirmCallback;
    view.tipLabel.text = [NSString stringWithFormat:@"确认要删除\"%@\"老师吗?", teacher.nickname];
    
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    [view showWithAnimation];
}

+ (void)showDeleteClassAlertView:(UIView *)superView
                           class:(Clazz *)classinfo
                sendCodeCallback:(SendDeleteTeacherCodeClickCallback)sendCodeCallback
                 confirmCallback:(ConfirmDeleteClickCallback)confirmCallback
{
    DeleteTeacherAlertView *view = [DeleteTeacherAlertView sharedInstance];
    if (view.superview != nil) {
        [view.timer invalidate];
        view.timer = nil;
        [view removeFromSuperview];
    }
    
    view.sendButton.enabled = YES;
    [view.sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    
    view.deleteButton.enabled = NO;
    
    //    view.codeTextField.enabled = NO;
    
    view.codeTextField.text = nil;
    
    view.sendCodeCallback = sendCodeCallback;
    view.confirmCallback = confirmCallback;
    view.tipLabel.text = [NSString stringWithFormat:@"确认要删除\"%@\"班级吗?", classinfo.name];
    
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
            [self.codeTextField becomeFirstResponder];
        }];
    });
}

+ (void)hideAnimated:(BOOL)animated {
    DeleteTeacherAlertView *alertView = [DeleteTeacherAlertView sharedInstance];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .3f;
        scaleAnimation.values = @[@1, @0];
        scaleAnimation.keyTimes = @[@0, @.3];
        scaleAnimation.repeatCount = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [alertView.contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        alertView.backgroundView.alpha = 1.f;
        [UIView animateWithDuration:0.3 animations:^{
            alertView.backgroundView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [alertView.timer invalidate];
            alertView.timer = nil;
            
            [alertView removeFromSuperview];
        }];
    });
}

- (IBAction)sendButtonPressed:(id)sender {
//    self.codeTextField.enabled = YES;
    self.deleteButton.enabled = YES;
    
    if (self.sendCodeCallback != nil) {
        self.sendCodeCallback();
    }
    
    [self startTiming];
}

- (void)startTiming {
    self.sendButton.enabled = NO;
    __block NSUInteger secondsLeft = 60;
    __weak DeleteTeacherAlertView *weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
                                                       if (secondsLeft == 0) {
                                                           [weakSelf.timer invalidate];
                                                           weakSelf.timer = nil;
                                                           
                                                           weakSelf.sendButton.enabled = YES;
                                                           [weakSelf.sendButton setTitle:@"重新发送" forState:UIControlStateNormal];

                                                           return;
                                                       }
                                                       
                                                       [weakSelf.sendButton setTitle:[NSString stringWithFormat:@"重新发送 %zds", (secondsLeft--)] forState:UIControlStateNormal];
                                                   }];
}


- (IBAction)cancelButtonPressed:(id)sender {
    [[self class] hideAnimated:YES];
}

- (IBAction)confirmButtonPressed:(id)sender {
    if (self.confirmCallback != nil) {
        self.confirmCallback(self.codeTextField.text);
    }
}

@end

