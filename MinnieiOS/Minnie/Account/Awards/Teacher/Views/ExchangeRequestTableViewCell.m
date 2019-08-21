//
//  ExchangeRequestTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeRequestTableViewCell.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const ExchangeRequestTableViewCellId = @"ExchangeRequestTableViewCellId";
CGFloat const ExchangeRequestTableViewCellHeight = 144.f;

@interface ExchangeRequestTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UIImageView *awardImageView;
@property (nonatomic, weak) IBOutlet UILabel *awardNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *exchangeButton;

@end

@implementation ExchangeRequestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 18.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
    self.exchangeButton.backgroundColor = [UIColor colorWithHex:0xFFAD27];
    self.exchangeButton.layer.cornerRadius = 12.f;
    self.exchangeButton.layer.masksToBounds = YES;
}

- (void)setupWithExchangeRequest:(ExchangeRecord *)record {
    
    [self.avatarImageView sd_setImageWithURL:[record.user.avatarUrl imageURLWithWidth:36.f]];
    self.nicknameLabel.text = record.user.nickname;
    
    [self.awardImageView sd_setImageWithURL:[record.award.imageUrl imageURLWithWidth:56.f]];
    self.awardNameLabel.text = record.award.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@星", @(record.award.price)];
    self.dateLabel.text = [Utils formatedDateString:record.time];
    if (record.state == 0) {
        self.exchangeButton.hidden = NO;
    } else {
        self.exchangeButton.hidden = YES;
    }
}

- (void)setupWithExchangeByClassRequest:(ExchangeAwardInfo *)record {
    
    [self.avatarImageView sd_setImageWithURL:[record.avatar imageURLWithWidth:36.f]];
    self.nicknameLabel.text = record.nickName;
    
    [self.awardImageView sd_setImageWithURL:[record.awardImageUrl imageURLWithWidth:56.f]];
    self.awardNameLabel.text = record.awardName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@星", @(record.awardPrice)];
    self.dateLabel.text = [Utils formatedDateString:record.exchangeTime];
    self.exchangeButton.hidden = NO;
}

- (IBAction)exchangeButtonPressed:(id)sender {
    if (self.exchangeCallback != nil) {
        self.exchangeCallback();
    }
}

@end

