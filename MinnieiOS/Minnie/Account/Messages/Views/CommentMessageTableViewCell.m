//
//  CommentMessageTableViewCell.m
//  X5
//
//  Created by yebw on 2017/9/12.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CommentMessageTableViewCell.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

CGFloat const CommentMessageTableViewCellHeight = 80;
NSString * const CommentMessageTableViewCellId = @"CommentMessageTableViewCellId";

@interface CommentMessageTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation CommentMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 22.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
}

- (void)setupWithMessage:(Comment *)message {
    [self.avatarImageView sd_setImageWithURL:[message.user.avatarUrl imageURLWithWidth:44.f]];
    
    self.nicknameLabel.text = message.user.nickname;
    self.timeLabel.text = [Utils formatedDateString:message.time];
    self.contentLabel.text = message.content;
    
    [self.thumbnailImageView sd_setImageWithURL:[message.videoUrl videoCoverUrlWithWidth:44.f height:44.f]];
}

@end

