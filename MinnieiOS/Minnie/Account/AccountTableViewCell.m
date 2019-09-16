//
//  AccountTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2017/12/16.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "UIColor+HEX.h"

NSString * const AccountTableViewCellId = @"AccountTableViewCellId";
CGFloat const AccountTableViewCellHeight = 124.f;

@interface AccountTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UILabel *messageCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *unexchangedCountLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *exchangeViewHeightConstraint;

@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
}

- (void)setup {
    
    if (APP.currentUser.authority == TeacherAuthorityManager ||
        APP.currentUser.authority == TeacherAuthoritySuperManager) {
        
        if (APP.currentUser.canExchangeRewards) {
            self.exchangeViewHeightConstraint.constant = 50.f;
        } else {
            self.exchangeViewHeightConstraint.constant = 0.f;
        }
    } else {
        self.exchangeViewHeightConstraint.constant = 0.f;
    }

}

- (void)updateWithUnreadMessageCount:(NSUInteger)count {
    if (count == 0) {
        self.messageCountLabel.hidden = YES;
    } else {
        self.messageCountLabel.hidden = NO;
        self.messageCountLabel.text = [NSString stringWithFormat:@"%@未读",@(count)];
    }
}

- (void)updateWithUnexchangedCount:(NSUInteger)count {
    if (count == 0) {
        self.unexchangedCountLabel.hidden = YES;
    } else {
        self.unexchangedCountLabel.hidden = NO;
        self.unexchangedCountLabel.text = [NSString stringWithFormat:@"%@未兑换",@(count)];
    }
}

- (IBAction)messageButtonPressed:(id)sender {
    if (self.messageCallback != nil) {
        self.messageCallback();
    }
}

- (IBAction)exchangeButtonPressed:(id)sender {
    if (self.exchangeCallback != nil) {
        self.exchangeCallback();
    }
}

@end

