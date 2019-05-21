//
//  GoodWorkTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "GoodWorkTableViewCell.h"
#import "UIColor+HEX.h"

CGFloat const GoodWorkTableViewCellHeight = 390;
NSString * const GoodWorkTableViewCellId = @"GoodWorkTableViewCellId";

@interface GoodWorkTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIView *completionRateBGView;
@property (nonatomic, weak) IBOutlet UIView *completionRateView;
@property (nonatomic, weak) IBOutlet UIView *termProgressBGView;
@property (nonatomic, weak) IBOutlet UIView *termProgressView;

@property (nonatomic, weak) IBOutlet UILabel *totalCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *perfectCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *greateCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *niceCountLabel;

@property (nonatomic, weak) IBOutlet UILabel *completionRateLabel;
@property (nonatomic, weak) IBOutlet UILabel *termProgressLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *completionRateViewWidthConstrait;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *termProgressViewWidthConstrait;

@property (weak, nonatomic) IBOutlet UILabel *goodJobLabel;

@property (weak, nonatomic) IBOutlet UILabel *passedLabel;

@property (weak, nonatomic) IBOutlet UILabel *unFinishedLabel;
@end

@implementation GoodWorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
    self.completionRateBGView.layer.cornerRadius = 6.f;
    self.completionRateBGView.layer.masksToBounds = YES;
    
    self.completionRateView.layer.cornerRadius = 6.f;
    self.completionRateView.layer.masksToBounds = YES;
    
    self.termProgressBGView.layer.cornerRadius = 6.f;
    self.termProgressBGView.layer.masksToBounds = YES;
    
    self.termProgressView.layer.cornerRadius = 6.f;
    self.termProgressView.layer.masksToBounds = YES;
}

- (void)update {
    NSArray *homeworks = APP.currentUser.homeworks;
    
    NSUInteger unfinshed = [homeworks[0] unsignedIntegerValue];
    NSUInteger passed = [homeworks[1] unsignedIntegerValue];
    NSUInteger goodJob = [homeworks[2] unsignedIntegerValue];
    NSUInteger veryNice = [homeworks[3] unsignedIntegerValue];
    NSUInteger great = [homeworks[4] unsignedIntegerValue];
    // 5星
    NSUInteger perfect = [homeworks[5] unsignedIntegerValue];
   
    // 未完成
    NSUInteger hardworking = [homeworks[6] unsignedIntegerValue];
    
    self.totalCountLabel.text = [NSString stringWithFormat:@"%@次", @(veryNice+great+perfect+hardworking)];

    self.niceCountLabel.text = [NSString stringWithFormat:@"x%@", @(veryNice)];
    self.greateCountLabel.text = [NSString stringWithFormat:@"x%@", @(great)];
    self.perfectCountLabel.text = [NSString stringWithFormat:@"x%@", @(perfect)];
    
    self.totalCountLabel.hidden = (veryNice+great+perfect+hardworking==0);
    self.niceCountLabel.hidden = veryNice==0;
    self.greateCountLabel.hidden = great==0;
    self.perfectCountLabel.hidden = (perfect==0);
    // 不再显示
    self.totalCountLabel.hidden = YES;
    
    self.unFinishedLabel.text = [NSString stringWithFormat:@"x%@", @(unfinshed)];
    self.passedLabel.text = [NSString stringWithFormat:@"x%@", @(passed)];
    self.goodJobLabel.text = [NSString stringWithFormat:@"x%@", @(goodJob)];
    
    self.unFinishedLabel.hidden = unfinshed==0;
    self.passedLabel.hidden = passed==0;
    self.goodJobLabel.hidden = goodJob==0;
    
    NSUInteger totalCount = unfinshed + passed + goodJob + veryNice + great + perfect + hardworking;
    CGFloat percent = (totalCount==0)?0:((totalCount - unfinshed)/(CGFloat)totalCount);

    if (percent==0 && totalCount==0) {
        self.completionRateLabel.text = @"作业完成率";
    } else {
        self.completionRateLabel.text = [NSString stringWithFormat:@"作业完成率: %zd/%zd", (totalCount - unfinshed), totalCount];
    }
    
    self.completionRateViewWidthConstrait.constant = (ScreenWidth - 48.f) * percent;
    
    NSInteger finishedCount = 0;
    long long now = [[NSDate date] timeIntervalSince1970] * 1000;
    for (NSNumber *timeNumber in APP.currentUser.clazz.dates) {
        long long time = [timeNumber longLongValue];
        if (time < now) {
            finishedCount ++;
        }
    }

    percent = finishedCount/(CGFloat)(APP.currentUser.clazz.dates.count);
    self.termProgressLabel.text = [NSString stringWithFormat:@"本学期进度: %@/%@", @(finishedCount), @(APP.currentUser.clazz.dates.count)];
    
    self.termProgressViewWidthConstrait.constant = (ScreenWidth - 48.f) * percent;
}

@end
