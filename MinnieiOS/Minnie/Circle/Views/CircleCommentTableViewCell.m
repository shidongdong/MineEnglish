//
//  CircleCommentTableViewCell.m
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Comment.h"
#import "UIColor+HEX.h"
#import "CircleCommentTableViewCell.h"

NSString * const CircleCommentTableViewCellId = @"CircleCommentTableViewCellId";

@interface CircleCommentTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet YYLabel *commentLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;

@end

@implementation CircleCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commentLabel.numberOfLines = 0;
    CGFloat width = ScreenWidth;
#if MANAGERSIDE
    width = (ScreenWidth - kRootModularWidth)/2.0;
#endif
    self.commentLabel.preferredMaxLayoutWidth = width - 90.f - 32.f;
    
}

- (IBAction)commentButtonPressed:(id)sender {
    if (self.commentReplyClickCallback != nil) {
        self.commentReplyClickCallback();
    }
}

+ (CGFloat)heightOfComment:(Comment *)comment
                isFirstOne:(BOOL)isFirstOne
                 isLastOne:(BOOL)isLastOne {
    if (comment.cellHeightInCircle > 0.1 && comment.isLastCommentInCircle == isLastOne) {
        return comment.cellHeightInCircle;
    }
    
    static CircleCommentTableViewCell *cellForCaculatingHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellForCaculatingHeight = [[[NSBundle mainBundle] loadNibNamed:@"CircleCommentTableViewCell" owner:nil options:nil] lastObject];
    });
    
    CGFloat height = 0.f;
    CGFloat width = ScreenWidth;
#if MANAGERSIDE
    width = (ScreenWidth - kRootModularWidth)/2.0;
#endif
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width-122, MAXFLOAT) text:[CircleCommentTableViewCell attributedStringWithComment:comment]];
    CGSize size = layout.textBoundingSize;
    height += size.height;

    if (isLastOne) {
        height += 12.f;
    } else {
        height += 6.f;
    }
    
    comment.cellHeightInCircle = height;
    comment.isLastCommentInCircle = isLastOne;
    
    return size.height;
}

- (void)setupWithComment:(Comment *)comment
              isFirstOne:(BOOL)isFirstOne
               isLastOne:(BOOL)isLastOne
                 hasMore:(BOOL)hasMore {
    if (isFirstOne) {
        if (!isLastOne) {
            self.bottomLayoutConstraint.constant = 0;
            self.bgImageView.image = [[UIImage imageNamed:@"gray_top_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 2, 5) resizingMode:UIImageResizingModeStretch];
            self.bgImageView.backgroundColor = [UIColor clearColor];
        } else {
            self.bottomLayoutConstraint.constant = 0;
            self.bgImageView.image = [[UIImage imageNamed:@"gray_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
            self.bgImageView.backgroundColor = [UIColor clearColor];
        }
    } else if (isLastOne) {
        self.bottomLayoutConstraint.constant = 6;
        if (!hasMore) {
            self.bgImageView.image = [[UIImage imageNamed:@"gray_bottom_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
            self.bgImageView.backgroundColor = [UIColor clearColor];
        } else {
            self.bgImageView.image = nil;
            self.bgImageView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        }
    } else {
        self.bottomLayoutConstraint.constant = 0;
        self.bgImageView.image = nil;
        self.bgImageView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    }
    
    NSAttributedString *attributedString = [CircleCommentTableViewCell attributedStringWithComment:comment];
    self.commentLabel.attributedText = attributedString;
}

+ (NSAttributedString *)attributedStringWithComment:(Comment *)comment {
    NSRange fromRange = NSMakeRange(0, comment.user.nickname.length);
    NSRange toRange = NSMakeRange(NSNotFound, NSNotFound);
    NSString *prefix = @"";
    if (comment.originalComment.commentId != 0) {
        prefix = [NSString stringWithFormat:@"%@回复%@: ", comment.user.nickname, comment.originalComment.user.nickname];
        toRange = NSMakeRange(fromRange.length+2, comment.originalComment.user.nickname.length);
    } else {
        prefix = [NSString stringWithFormat:@"%@: ", comment.user.nickname];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:prefix]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:comment.content]];
    
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x2A2A2A]} range:NSMakeRange(0, [attributedString string].length)];
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, [attributedString string].length)];
    [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x7072B4]} range:fromRange];
    
    if (toRange.location != NSNotFound) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x7072B4]} range:toRange];
    }
    
    return attributedString;
}

@end

