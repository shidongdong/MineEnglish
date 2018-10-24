//
//  DateButton.m
//  X5
//
//  Created by yebw on 2017/9/17.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "DateButton.h"
#import <Masonry/Masonry.h>
#import "UIColor+HEX.h"

@interface DateButton()

@property (nonatomic, strong) UIImageView *circleBGImageView;
@property (nonatomic, strong) UIImageView *todayLineImageView;

@end

@implementation DateButton

@synthesize today = _today;

- (void)setCircleBGColor:(UIColor *)color {
    if (color == nil) {
        self.circleBGImageView.backgroundColor = nil;
    } else {
        if (self.circleBGImageView == nil) {
            self.circleBGImageView = [[UIImageView alloc] init];
            self.circleBGImageView.layer.cornerRadius = 12.f;
            self.circleBGImageView.layer.masksToBounds = YES;
            [self insertSubview:self.circleBGImageView belowSubview:self.titleLabel];
            [self.circleBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(24.f, 24.f));
                make.center.equalTo(self);
            }];
        }
        self.circleBGImageView.backgroundColor = color;
    }
}

- (void)setToday:(BOOL)today {
    _today = today;
    
    if (today) {
        self.todayLineImageView = [[UIImageView alloc] init];
        self.todayLineImageView.layer.cornerRadius = 2.f;
        self.todayLineImageView.layer.masksToBounds = YES;
        self.todayLineImageView.backgroundColor = [UIColor colorWithHex:0xFFC600];
        [self insertSubview:self.todayLineImageView aboveSubview:self.titleLabel];
        [self.todayLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10.f, 3.f));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).with.offset(-2.f);
        }];
    } else {
        [self.todayLineImageView removeFromSuperview];
        self.todayLineImageView = nil;
    }
}
@end
