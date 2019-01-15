//
//  ExchangeAwardView.m
//  X5
//
//  Created by yebw on 2017/9/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeAwardView.h"
#import "Award.h"
#import <Masonry/Masonry.h>
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ExchangeAwardView()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIImageView *awardImageView;
@property (nonatomic, weak) IBOutlet UILabel *awardNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;
@property (nonatomic, weak) IBOutlet UIButton *exchangeButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) ExchangeButtonClickCallback exchangeCallback;

@end

@implementation ExchangeAwardView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.exchangeButton.layer.cornerRadius = 12.f;
    self.exchangeButton.layer.masksToBounds = YES;
    self.exchangeButton.backgroundColor = nil;
    [self.exchangeButton setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:1.f]] forState:UIControlStateNormal];
    [self.exchangeButton setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0 green:0x98/255.f blue:0xFE/255.f alpha:.8f]] forState:UIControlStateHighlighted];
    [self.exchangeButton setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:0xDD/255.f green:0xDD/255.f blue:0xDD/255.f alpha:1.f]] forState:UIControlStateDisabled];
    
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

+ (void)showExchangeAwardViewInView:(UIView *)superView
                          withAward:(Award *)award
                          starCount:(long long)starCount
                   exchangeCallback:(ExchangeButtonClickCallback)exchangeCallback {
    ExchangeAwardView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ExchangeAwardView class]) owner:nil options:nil] lastObject];
    view.exchangeCallback = exchangeCallback;
    
    view.awardNameLabel.text = award.name;
    view.costLabel.text = [NSString stringWithFormat:@"需要%@颗星星", @(award.price)];
    [view.awardImageView sd_setImageWithURL:[award.imageUrl imageURLWithWidth:271.f]];
    
    [superView addSubview:view];
    
    if (award.price > starCount) {
        [view.exchangeButton setTitle:@"星星不够喔" forState:UIControlStateNormal];
        view.exchangeButton.enabled = NO;
    } else {
        [view.exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
    }
    
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
        self.cancelButton.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1.f;
            self.cancelButton.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    });
}

- (void)hideWithAnimation {
    self.cancelButton.hidden = YES;
    
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

- (IBAction)cancelButtonPressed:(id)sender {
    [self hideWithAnimation];
}

- (IBAction)exchangeButtonPressed:(id)sender {
    
    
    
    
    if (self.exchangeCallback != nil) {
        self.exchangeCallback();
    }
    
    [self removeFromSuperview];
}

@end

