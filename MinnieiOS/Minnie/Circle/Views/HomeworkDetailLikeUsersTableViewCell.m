//
//  HomeworkDetailLikeUsersTableViewCell.m
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworkDetailLikeUsersTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

static NSInteger numberOfColumns = 0;

NSString * const HomeworkDetailLikeUsersTableViewCellId = @"HomeworkDetailLikeUsersTableViewCellId";

@interface HomeworkDetailLikeUsersTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *contentBgImageView;
@property (nonatomic, weak) IBOutlet UIView *avatarsContainerView;

@end

@implementation HomeworkDetailLikeUsersTableViewCell

+ (void)load {
    NSInteger defaultSpace = 4.f;
    NSInteger avatarWidth = 36.f;
    
    if (numberOfColumns == 0) {
        CGFloat usersContainerViewWidth = [UIScreen mainScreen].bounds.size.width - 52.f - 32.f;
        
        for (NSInteger i=5;; i++) {
            CGFloat width = i * avatarWidth + (i - 1) * defaultSpace;
            if (width > usersContainerViewWidth) {
                numberOfColumns = i - 1;
                break;
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentBgImageView.image = [[UIImage imageNamed:@"gray_corner_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
}

- (void)setupWithLikeUsers:(NSArray <User *> *)users {
    for (UIView *view in self.avatarsContainerView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat space =  (([UIScreen mainScreen].bounds.size.width - 52.f - 32.f) - numberOfColumns * 36.f)/(numberOfColumns-1);
    
    for (NSInteger index=0; index<users.count; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 18.f;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [self.avatarsContainerView addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarsContainerView).with.offset((index%numberOfColumns)*(space+36.f));
            make.top.equalTo(self.avatarsContainerView).with.offset(index/numberOfColumns*(4+36.f));
            make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
        }];
        
        [imageView sd_setImageWithURL:[users[index].avatarUrl imageURLWithWidth:36.f]];
    }
}

// 确认一行可以排几个头像
+ (CGFloat)heightWithLikeUsers:(NSArray <User *> *)users {
    NSInteger defaultSpace = 4.f;
    NSInteger avatarWidth = 36.f;

    NSInteger lines = ceil(users.count/(float)numberOfColumns);
    CGFloat height = lines * avatarWidth + (lines-1)*defaultSpace;
    
    return height + 14.f;
}

@end

