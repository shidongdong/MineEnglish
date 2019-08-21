//
//  ExchangeRecordTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeRecordTableViewCell.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const ExchangeRecordTableViewCellId = @"ExchangeRecordTableViewCellId";
CGFloat const ExchangeRecordTableViewCellHeight = 92.f;

@interface ExchangeRecordTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIImageView *awardImageView;
@property (nonatomic, weak) IBOutlet UILabel *awardNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end

@implementation ExchangeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
}

- (void)setupWithExchangeRecord:(ExchangeRecord *)record {
    [self.awardImageView sd_setImageWithURL:[record.award.imageUrl imageURLWithWidth:56.f]];
    self.awardNameLabel.text = record.award.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@星", @(record.award.price)];
    self.dateLabel.text = [Utils formatedDateString:record.time];
    self.stateLabel.text = record.state==0 ? @"礼物还在老师手里" : @"已兑换";
    if (record.state == 0) {
        self.stateLabel.textColor = [UIColor colorWithHex:0x999999];
    } else {
        self.stateLabel.textColor = [UIColor colorWithHex:0x00CE00];
    }
}

@end
