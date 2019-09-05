//
//  CircleLikeUsersTableViewCell.m
//  X5
//
//  Created by yebw on 2017/10/8.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "UIColor+HEX.h"
#import "CircleLikeUsersTableViewCell.h"

NSString * const CircleLikeUsersTableViewCellId = @"CircleLikeUsersTableViewCellId";

@interface CircleLikeUsersTableViewCell()

@property (nonatomic, weak) IBOutlet YYLabel *likeUsersLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@end

@implementation CircleLikeUsersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.bgImageView.layer.cornerRadius = 4.f;
    self.bgImageView.layer.masksToBounds = YES;
    
    self.likeUsersLabel.numberOfLines = 0;
    CGFloat width = ScreenWidth;
#if MANAGERSIDE
    width = kColumnThreeWidth;
#endif
    self.likeUsersLabel.preferredMaxLayoutWidth = width - 12 * 2 - 12 - 70 - 16;
}

- (void)setupWithLikeUsers:(NSArray <User *> *)users {
    NSMutableArray *nicknames = [NSMutableArray array];
    for (User *user in users) {
        [nicknames addObject:user.nickname];
    }

    NSString *nicknamesString = [nicknames componentsJoinedByString:@"，"];
    nicknamesString = [NSString stringWithFormat:@" %@ ", nicknamesString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[NSAttributedString yy_attachmentStringWithEmojiImage:[UIImage imageNamed:@"icon_like_small"] fontSize:10.f]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:nicknamesString]];

    self.likeUsersLabel.attributedText = attributedString;
    self.likeUsersLabel.textColor = [UIColor colorWithHex:0x7072B4];
}

+ (CGFloat)heightWithLikeUsers:(NSArray <User *> *)users {
    static CircleLikeUsersTableViewCell *cellForCaculatingHeight = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellForCaculatingHeight = [[[NSBundle mainBundle] loadNibNamed:@"CircleLikeUsersTableViewCell" owner:nil options:nil] lastObject];
    });
    
    [cellForCaculatingHeight setupWithLikeUsers:users];

    return [cellForCaculatingHeight systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

@end
