//
//  AwardCollectionViewCell.m
//  X5
//
//  Created by yebw on 2017/9/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "TeacherAwardCollectionViewCell.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const TeacherAwardCollectionViewCellId = @"TeacherAwardCollectionViewCellId";

@interface TeacherAwardCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation TeacherAwardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
}

+ (CGSize)size {
   
    NSInteger width;
    NSInteger height;
#if MANAGERSIDE

    width = floor(((ScreenWidth - kRootModularWidth)/2.0 + 80 - 4 * 12.f)/3.f);
    height = (width - 24) + 12 + 54;
    
#else
    
    width = floor((ScreenWidth - 3 * 12.f)/2.f);
    height = (width - 24) + 12 + 54;
    
#endif
    
    
    return CGSizeMake(width, height);
}

- (void)setupWithAward:(Award *)award {
    self.awardNameLabel.text = award.name;
    self.starCostLabel.text = [NSString stringWithFormat:@"需要%@颗星星", @(award.price)];
    
    if (award.imageUrl.length > 0) {
        [self.awardImageView sd_setImageWithURL:[award.imageUrl imageURLWithWidth:150.f]];
    }
}

@end
