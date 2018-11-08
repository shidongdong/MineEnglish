//
//  SegmentControl.m
//  X5
//
//  Created by yebw on 2017/9/10.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "SegmentControl.h"
#import <Masonry/Masonry.h>

@interface SegmentControl ()

@property (nonatomic, weak) IBOutlet UIImageView *sliderImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderImageViewLeading;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *sliderImageViewWidth;

@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@end

@implementation SegmentControl

#pragma mark - Public

- (void)awakeFromNib {
    [super awakeFromNib];

    self.sliderImageView.layer.cornerRadius = 2.f;
    self.sliderImageView.layer.masksToBounds = YES;
    
    self.sliderImageView.hidden = YES;
    self.sliderImageViewWidth.constant = 24.f;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.sliderImageView.hidden) {

        [self.button1 setTitle:self.titles[0] forState:UIControlStateNormal];
        [self.button2 setTitle:self.titles[1] forState:UIControlStateNormal];
        if (self.titles.count > 2)
        {
            [self.button3 setTitle:self.titles[2] forState:UIControlStateNormal];
        }
        self.sliderImageView.hidden = NO;
        [self setSelectedTab:self.selectedIndex animated:NO shouldCallBack:NO];
    }
}

- (IBAction)buttonPressed:(UIButton *)button {
    if (button == self.button1) {
        [self setSelectedTab:0 animated:YES shouldCallBack:YES];
    } else if(button == self.button2){
        [self setSelectedTab:1 animated:YES shouldCallBack:YES];
    }
    else
    {
        [self setSelectedTab:2 animated:YES shouldCallBack:YES];
    }
}

- (void)setSelectedTab:(NSUInteger)index
              animated:(BOOL)animated
        shouldCallBack:(BOOL)callback {
    self.selectedIndex = index;

    CGFloat leadingOffsetInTab = (self.bounds.size.width/self.titles.count - self.sliderImageViewWidth.constant)/2;
    CGFloat leading = index * self.bounds.size.width/self.titles.count + leadingOffsetInTab;

    if (animated) {
        [self.sliderImageView.superview layoutIfNeeded];
        self.sliderImageViewLeading.constant = leading;
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.sliderImageView.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {
                         }];
    } else {
        self.sliderImageViewLeading.constant = leading;
        [self.sliderImageView.superview layoutIfNeeded];
    }

    if (index == 0) {
        self.button1.enabled = NO;
        self.button2.enabled = YES;
        self.button3.enabled = YES;
    } else if(index == 1){
        self.button1.enabled = YES;
        self.button2.enabled = NO;
        self.button3.enabled = YES;
    }
    else
    {
        self.button1.enabled = YES;
        self.button2.enabled = YES;
        self.button3.enabled = NO;
    }
    if (self.indexChangeHandler && callback) {
        self.indexChangeHandler(index);
    }
}

- (void)setPersent:(CGFloat)persent {
    NSInteger index = MAX(0, ceil(persent));
    self.selectedIndex = index;
    CGFloat leadingOffsetInTabButton = (self.bounds.size.width/self.titles.count - self.sliderImageViewWidth.constant)/2;
    CGFloat leading = self.bounds.size.width/self.titles.count * persent + leadingOffsetInTabButton;
    
    self.sliderImageViewLeading.constant = leading;
    
    if (index == 0) {
        self.button1.enabled = NO;
        self.button2.enabled = YES;
        self.button3.enabled = YES;
    } else if(index == 1) {
        self.button1.enabled = YES;
        self.button2.enabled = NO;
        self.button3.enabled = YES;
    }
    else
    {
        self.button1.enabled = YES;
        self.button2.enabled = YES;
        self.button3.enabled = NO;
    }
}
@end
