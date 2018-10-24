//
//  ProgressHUD.m
//  X5
//
//  Created by yebw on 2017/10/9.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ProgressHUD.h"
#import "UIColor+HEX.h"
#import <Masonry/Masonry.h>

@interface ProgressHUD()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *loadImageView;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;

@property (nonatomic, assign) BOOL stopped;

@end

@implementation ProgressHUD

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 12.f;
    self.contentView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.contentView.layer.shadowColor = [UIColor colorWithHex:0x000000].CGColor;
    self.contentView.layer.shadowRadius = 3;
    self.contentView.layer.shadowOffset = CGSizeMake(2, 4);
    
}

+ (instancetype)sharedHUD {
    static ProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[NSBundle mainBundle] loadNibNamed:@"ProgressHUD" owner:nil options:nil] lastObject];
    });
    
    return instance;
}

- (void)showAnimatedInView:(UIView *)superView {
    ProgressHUD *instance =  [[self class] sharedHUD];
    
    instance.loadImageView.image = [UIImage imageNamed:@"pop_loading"];
    instance.progressLabel.text = @"上传中...";
    if (instance.superview == nil) {
        [superView addSubview:instance];
        [instance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView);
        }];
    }
    
    self.stopped = NO;
    
    [self showWithAnimation];
}

- (void)hideAnimated {
    [self hideWithAnimation];
}

- (void)updateWithProgress:(CGFloat)progress text:(NSString *)text {
    progress = MAX(0, MIN(1, progress));
    
    if (progress == 1) {
        self.stopped = YES;
        [self.contentView.layer removeAllAnimations];
        [self.loadImageView.layer removeAllAnimations];

        self.loadImageView.image = [UIImage imageNamed:@"pop_finish"];
        if (text.length > 0) {
            self.progressLabel.text = text;
        } else {
            self.progressLabel.text = @"上传完成";
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideWithAnimation];
        });
    } else {
        if (progress == 0.f) {
            self.progressLabel.text = text;
        } else {
            self.progressLabel.text = [NSString stringWithFormat:@"正在上传 %.f%%", progress*100];
        }
    }
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
            if (finished && !self.stopped) {
                [self rotate];
            }
        }];
    });
}

- (void)rotate {
    // 执行动画
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.loadImageView.transform = CGAffineTransformRotate(self.loadImageView.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         if (!self.stopped) {
                             [self rotate];
                         } else {
                             self.loadImageView.transform = CGAffineTransformIdentity;
                         }
                     }];
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

@end

