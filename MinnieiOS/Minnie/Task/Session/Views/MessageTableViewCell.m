//
//  MessageTableViewCell.m
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 22.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.sendingIndicatorView.hidden = YES;
    self.retryButton.hidden = YES;
    self.retryButton.backgroundColor = [UIColor clearColor];
}

+ (CGFloat)heightOfMessage:(AVIMTypedMessage *)message {
    return 0;
}

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message {
    self.user = user;
    self.message = message;

    [self.avatarImageView sd_setImageWithURL:[user.avatarUrl imageURLWithWidth:44.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
    
    self.retryButton.hidden = YES;
    self.sendingIndicatorView.hidden = YES;
    if (message.status == AVIMMessageStatusFailed) {
        self.retryButton.hidden = NO;
    } else if (message.status == AVIMMessageStatusSending) {
        self.sendingIndicatorView.hidden = NO;
    }
}

- (IBAction)resendButtonPressed:(id)sender {
    if (self.resendCallback != nil) {
        self.retryButton.hidden = YES;
        self.sendingIndicatorView.hidden = NO;
        
        self.resendCallback();
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.retryButton.hidden = YES;
    self.sendingIndicatorView.hidden = YES;
}

@end

