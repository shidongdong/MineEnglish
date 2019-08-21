//
//  NoticeMessageHeadTableViewCell.m
//  X5
//
//  Created by yebw on 2017/12/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessageHeadTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const NoticeMessageHeadTableViewCellId = @"NoticeMessageHeadTableViewCellId";

@interface NoticeMessageHeadTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageTitleLabel;

@end

@implementation NoticeMessageHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 16.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.messageTitleLabel.preferredMaxLayoutWidth = ScreenWidth - 2 * 24.f;
}

+ (CGFloat)heightWithMessage:(NoticeMessage *)message {
    if (message.cellHeight > 0) {
        return message.cellHeight;
    }

    static NoticeMessageHeadTableViewCell *cellForCaculatingHeight = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellForCaculatingHeight = [[[NSBundle mainBundle] loadNibNamed:@"NoticeMessageHeadTableViewCell" owner:nil options:nil] lastObject];
    });
    
    cellForCaculatingHeight.messageTitleLabel.text = message.title;

    CGSize size = [cellForCaculatingHeight systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    message.cellHeight = size.height;

    return size.height;
}

- (void)setupWithMessage:(NoticeMessage *)message {
    [self.avatarImageView sd_setImageWithURL:[message.user.avatarUrl imageURLWithWidth:32.f]];
    
    self.timeLabel.text = [Utils formatedDateString:message.time];
    self.messageTitleLabel.text = message.title;
}

@end
