//
//  HomeworkDetailCommentTableViewCell.m
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworkDetailCommentTableViewCell.h"
#import "UIColor+HEX.h"
#import <YYText/YYText.h>
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const HomeworkDetailCommentTableViewCellId = @"HomeworkDetailCommentTableViewCellId";

@interface HomeworkDetailCommentTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *commentIconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet YYLabel *commentLabel;

@property (nonatomic, weak) IBOutlet UIImageView *contentBGImageView;
@property (nonatomic, weak) IBOutlet UIImageView *contentSeperatorLineImageView;

@end

@implementation HomeworkDetailCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 18.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.commentLabel.numberOfLines = 0;
    
    self.commentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 96 - 32;
}

- (IBAction)commentButtonPressed:(id)sender {
    if (self.commentReplyClickCallback != nil) {
        self.commentReplyClickCallback();
    }
}

+ (CGFloat)heightOfComment:(Comment *)comment
                isFirstOne:(BOOL)isFirstOne
                 isLastOne:(BOOL)isLastOne {
    if (comment.cellHeightInDetail > 0.1) {
        return comment.cellHeightInDetail;
    }
    
    static HomeworkDetailCommentTableViewCell *cellForCaculatingHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellForCaculatingHeight = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkDetailCommentTableViewCell" owner:nil options:nil] lastObject];
    });
    
    NSAttributedString *attributedString = [HomeworkDetailCommentTableViewCell attributedStringWithComment:comment];
    
    CGFloat height = 45.f; // 评论以外的其它部分高度总和
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth-128, MAXFLOAT) text:attributedString];
    CGSize size = layout.textBoundingSize;
    height += size.height;
    
    return height;
}

- (void)setupWithComment:(Comment *)comment
              isFirstOne:(BOOL)isFirstOne
               isLastOne:(BOOL)isLastOne {
    [self setupWithComment:comment
                isFirstOne:isFirstOne
                 isLastOne:isLastOne
       forCaculatingHeight:NO];
}

- (void)setupWithComment:(Comment *)comment
              isFirstOne:(BOOL)isFirstOne
               isLastOne:(BOOL)isLastOne
     forCaculatingHeight:(BOOL)forCaculatingHeight {
    if (!forCaculatingHeight) {
        self.commentIconImageView.hidden = !isFirstOne;
        self.contentSeperatorLineImageView.hidden = isLastOne;
        
        NSString *bgImageName = nil;
        if (isFirstOne) {
            if (isLastOne) {
                bgImageName = @"gray_corner_bg";
            } else {
                bgImageName = @"gray_top_corner_bg";
            }
        } else {
            if (isLastOne) {
                bgImageName = @"gray_bottom_corner_bg";
            } else {
                bgImageName = nil;
            }
        }
        
        if (bgImageName == nil) {
            self.contentBGImageView.image = nil;
            self.contentBGImageView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        } else {
            self.contentBGImageView.backgroundColor = [UIColor clearColor];
            self.contentBGImageView.image = [[UIImage imageNamed:bgImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
        }
        
        [self.avatarImageView sd_setImageWithURL:[comment.user.avatarUrl imageURLWithWidth:36.f]];
        
        self.nicknameLabel.text = comment.user.nickname;
        self.timeLabel.text = [Utils formatedDateString:comment.time];
    }
    
    self.commentLabel.attributedText = [self.class attributedStringWithComment:comment];
}

+ (NSAttributedString *)attributedStringWithComment:(Comment *)comment {
    NSRange toRange = NSMakeRange(NSNotFound, NSNotFound);
    NSString *prefix = @"";
    if (comment.originalComment.commentId != 0) {
        prefix = [NSString stringWithFormat:@"回复%@: ", comment.originalComment.user.nickname];
        toRange = NSMakeRange(2, comment.originalComment.user.nickname.length);
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:prefix]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:comment.content]];
    
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, [attributedString string].length)];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666]} range:NSMakeRange(0, [attributedString string].length)];
    
    if (toRange.location != NSNotFound) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x7072B4]} range:toRange];
    }
    
    return attributedString;
}


@end

