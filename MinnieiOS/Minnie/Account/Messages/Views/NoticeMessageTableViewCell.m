//
//  NoticeMessageTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessageTableViewCell.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const NoticeMessageTableViewCellId = @"NoticeMessageTableViewCellId";

@interface NoticeMessageTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation NoticeMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
    self.avatarImageView.layer.cornerRadius = 22.f;
    self.avatarImageView.layer.masksToBounds = YES;

    self.messageTitleLabel.preferredMaxLayoutWidth = ScreenWidth - 80 - 24;
}

+ (CGFloat)heightWithMessage:(NoticeMessage *)message {
    if (message.cellHeight > 0) {
        return message.cellHeight;
    }
    
    static NoticeMessageTableViewCell *cellForCaculatingHeight = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellForCaculatingHeight = [[[NSBundle mainBundle] loadNibNamed:@"NoticeMessageTableViewCell" owner:nil options:nil] lastObject];
    });
    
    cellForCaculatingHeight.messageTitleLabel.text = message.title;
    
    CGSize size = [cellForCaculatingHeight systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    message.cellHeight = size.height;
    
    return size.height;
}

- (void)setupWithMessage:(NoticeMessage *)message {
    [self.avatarImageView sd_setImageWithURL:[message.user.avatarUrl imageURLWithWidth:44.f]];
    
    self.nameLabel.text = message.user.nickname;
    self.timeLabel.text = [Utils formatedDateString:message.time];
    self.messageTitleLabel.text = message.title;
}

@end
