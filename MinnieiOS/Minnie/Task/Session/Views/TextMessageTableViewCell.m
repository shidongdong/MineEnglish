//
//  TextMessageTableViewCell.m
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "TextMessageTableViewCell.h"

NSString * const LeftTextMessageTableViewCellId = @"LeftTextMessageTableViewCellId";
NSString * const RightTextMessageTableViewCellId = @"RightTextMessageTableViewCellId";

@interface TextMessageTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *messageTextLabel;
@property (nonatomic, weak) IBOutlet UIImageView *textBackgroundImageView;

@end

@implementation TextMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 标签的最大宽度
    self.messageTextLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 64 * 2 - 12 - 20;
}

+ (CGFloat)heightOfMessage:(AVIMTypedMessage *)message {
    CGFloat height = 0.f;
    if (![message isKindOfClass:[AVIMTextMessage class]]) {
        return height;
    }
    
    static TextMessageTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 左右计算高度都是一样的
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RightTextMessageTableViewCell" owner:nil options:nil] lastObject];
    });
    
    [cell setupWithUser:nil message:message];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message {
    [super setupWithUser:user message:message];
    
    if (![message isKindOfClass:[AVIMTextMessage class]]) {
        return ;
    }
    
    NSString *backgroundImageName = message.ioType==AVIMMessageIOTypeIn?@"对话框_白色":@"对话框_蓝色";
    UIImage *image = [UIImage imageNamed:backgroundImageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20) resizingMode:UIImageResizingModeStretch];
    self.textBackgroundImageView.image = image;
    
    AVIMTextMessage *textMessage = (AVIMTextMessage *)(message);
    self.messageTextLabel.text = textMessage.text;
}

@end


