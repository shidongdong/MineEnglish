//
//  AlertView.m
//  AlertDemo
//
//  Created by yebingwei on 2017/9/17.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "AlertView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface AlertView()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, copy) AlertActionCallback actionButtonCallback;

@property (nonatomic, weak) IBOutlet UIButton *action1Button;
@property (nonatomic, copy) AlertActionCallback action1ButtonCallback;

@property (nonatomic, weak) IBOutlet UIButton *action2Button;
@property (nonatomic, copy) AlertActionCallback action2ButtonCallback;

@end

@implementation AlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.actionButton.layer.cornerRadius = 12.f;
    self.actionButton.layer.masksToBounds = YES;
    self.actionButton.backgroundColor = nil;
    [self.actionButton setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:1.f]] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:.8f]] forState:UIControlStateHighlighted];

    self.action1Button.layer.cornerRadius = 12.f;
    self.action1Button.layer.masksToBounds = YES;
    self.action1Button.layer.borderWidth = 0.5;
    self.action1Button.layer.borderColor = [UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:1.f].CGColor;

    self.action2Button.layer.cornerRadius = 12.f;
    self.action2Button.layer.masksToBounds = YES;
    self.action2Button.backgroundColor = nil;
    [self.action2Button setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:1.f]] forState:UIControlStateNormal];
    [self.action2Button setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:.8f]] forState:UIControlStateHighlighted];
    
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

- (IBAction)actionButtonPressed:(id)sender {
    if (self.actionButtonCallback != nil) {
        self.actionButtonCallback();
    }
    
    [self hideWithAnimation];
}

- (IBAction)action1ButtonPressed:(id)sender {
    if (self.action1ButtonCallback != nil) {
        self.action1ButtonCallback();
    }
    
    [self hideWithAnimation];
}

- (IBAction)action2ButtonPressed:(id)sender {
    if (self.action2ButtonCallback != nil) {
        self.action2ButtonCallback();
    }
    
    [self hideWithAnimation];
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
        }];
    });
}

- (void)hideWithAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .3f;
        scaleAnimation.values = @[@1, @0];
        scaleAnimation.keyTimes = @[@0, @.3];
        scaleAnimation.repeatCount = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        self.backgroundView.alpha = 1.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

+ (instancetype)showInView:(UIView *)superView
                 withImage:(UIImage *)image
                     title:(NSString *)title
                   message:(NSString *)message
                    action:(NSString *)action
            actionCallback:(AlertActionCallback)callback {
    AlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AlertView class])
                                                          owner:nil
                                                        options:nil] firstObject];
    
    alertView.iconImageView.image = image;
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    
    [alertView.actionButton setTitle:action forState:UIControlStateNormal];
    alertView.actionButtonCallback = callback;
    
    [superView addSubview:alertView];
    [AlertView addConstraintsWithAlertView:alertView inSuperView:superView];
    
    [alertView showWithAnimation];
    
    return alertView;
}

+ (instancetype)showInView:(UIView *)superView
              withImageURL:(NSString *)imageURL
                     title:(NSString *)title
                   message:(NSString *)message
                    action:(NSString *)action
            actionCallback:(AlertActionCallback)callback {
    AlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AlertView class])
                                                          owner:nil
                                                        options:nil] firstObject];
    
    [alertView.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    
    [alertView.actionButton setTitle:action forState:UIControlStateNormal];
    alertView.actionButtonCallback = callback;
    
    [superView addSubview:alertView];
    [AlertView addConstraintsWithAlertView:alertView inSuperView:superView];
    
    [alertView showWithAnimation];
    
    return alertView;
}


+ (instancetype)showInView:(UIView *)superView
                 withImage:(UIImage *)image
                     title:(NSString *)title
                   message:(NSString *)message
                   action1:(NSString *)action1
           action1Callback:(AlertActionCallback)callback1
                   action2:(NSString *)action2
           action2Callback:(AlertActionCallback)callback2 {
    AlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AlertView class])
                                                          owner:nil
                                                        options:nil] lastObject];
    
    alertView.iconImageView.image = image;
    alertView.titleLabel.text = title;
    alertView.messageLabel.text = message;
    
    [alertView.action1Button setTitle:action1 forState:UIControlStateNormal];
    alertView.action1ButtonCallback = callback1;
    
    [alertView.action2Button setTitle:action2 forState:UIControlStateNormal];
    alertView.action2ButtonCallback = callback2;
    
    [superView addSubview:alertView];
    [AlertView addConstraintsWithAlertView:alertView inSuperView:superView];
    
    [alertView showWithAnimation];
    
    return alertView;
}

+ (void)addConstraintsWithAlertView:(AlertView *)alertView inSuperView:(UIView *)superView {
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:superView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:superView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alertView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    [superView addConstraints:@[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]];
}

@end
