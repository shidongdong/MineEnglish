//
//  EmojiMessageTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/3/27.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "EmojiMessageTableViewCell.h"

CGFloat const EmojiMessageTableViewCellHeight = 152.f;

NSString * const LeftEmojiMessageTableViewCellId = @"LeftEmojiMessageTableViewCellId";
NSString * const RightEmojiMessageTableViewCellId = @"RightEmojiMessageTableViewCellId";

@interface EmojiMessageTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *emojiImageView;

@end

@implementation EmojiMessageTableViewCell

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message {
    [super setupWithUser:user message:message];

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", message.text]];

    [self.emojiImageView setImage:image];
}
@end
