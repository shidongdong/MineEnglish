//
//  CircleAndStarTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleAndStarTableViewCell.h"
#import "UIColor+HEX.h"

CGFloat const CircleAndStarTableViewCellHeight = 104;
NSString * const CircleAndStarTableViewCellId = @"CircleAndStarTableViewCellId";

@interface CircleAndStarTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *classmateImageView;
@property (nonatomic, weak) IBOutlet UIImageView *starImageView;

@property (nonatomic, weak) IBOutlet UILabel *classmateUpdateCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *starCountLabel;


@end

@implementation CircleAndStarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
//    self.classmateImageView.layer.cornerRadius = 22.f;
//    self.classmateImageView.layer.masksToBounds = YES;
//
//    self.starImageView.layer.cornerRadius = 22.f;
//    self.starImageView.layer.masksToBounds = YES;
}

- (IBAction)circleButtonPressed:(id)sender {
    if (self.circleClickCallback != nil) {
        self.circleClickCallback();
    }
}

- (IBAction)starButtonPressed:(id)sender {
    if (self.starClickCallback) {
        self.starClickCallback();
    }
}

- (void)update {
    self.classmateUpdateCountLabel.text = [NSString stringWithFormat:@"%@更新", @(APP.currentUser.circleUpdate)];
    self.starCountLabel.text = [NSString stringWithFormat:@"%@", @(APP.currentUser.starCount)];

    self.classmateUpdateCountLabel.hidden = APP.currentUser.circleUpdate==0;
    self.starCountLabel.hidden = APP.currentUser.starCount==0;
}

@end
