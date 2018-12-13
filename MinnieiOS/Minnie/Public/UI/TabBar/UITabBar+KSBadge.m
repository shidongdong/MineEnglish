//
//  UITabBar+KSBadge.m
//  KomectSport
//
//  Created by 栋栋 施 on 17/1/9.
//  Copyright © 2017年 CMCC. All rights reserved.
//

#import "UITabBar+KSBadge.h"
#import "Masonry.h"

@implementation UITabBar (KSBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index totalTabbarCount:(NSInteger)total withInfo:(NSInteger)count{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    if (count == 0)
    {
        return;
    }
    
    CGFloat tabbarWidth = ScreenWidth / total;
    
    if (count == -1)
    {
        UIView * redIconView = [self viewWithTag:888 + index];
        if (!redIconView) {
            //显示小红点
            UIView *badgeView = [[UIView alloc]init];
            badgeView.frame = CGRectMake(tabbarWidth * index + 5, 5, 8, 8);
            badgeView.tag = 888 + index;
            badgeView.layer.cornerRadius = 4;
            badgeView.backgroundColor = [UIColor colorWithHex:0xFF4858];
            [self addSubview:badgeView];
        }
    }
    else if (count == 0)
    {
        //移除相应的红点
        [self removeBadgeOnItemIndex:index];
    }
    else
    {
        UILabel * redIconInfoLabel = (UILabel *)[self viewWithTag:888 + index];
        
        if (!redIconInfoLabel)
        {
            redIconInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            redIconInfoLabel.layer.cornerRadius = 8.0;
            redIconInfoLabel.layer.masksToBounds = YES;
            redIconInfoLabel.tag = 888+ index;
            redIconInfoLabel.backgroundColor = [UIColor colorWithHex:0xFF4858];
            redIconInfoLabel.textColor = [UIColor whiteColor];
            redIconInfoLabel.textAlignment = NSTextAlignmentCenter;
            redIconInfoLabel.font = [UIFont boldSystemFontOfSize:10.0];
            [self addSubview:redIconInfoLabel];
        }
        NSString * badgeStr = [NSString stringWithFormat:@"%ld",count];
        CGSize size = [badgeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, redIconInfoLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : redIconInfoLabel.font} context:nil].size;
        
        if (size.width < 16.0f)
        {
            size.width = 16.0f;
        }
        
        redIconInfoLabel.frame = CGRectMake(tabbarWidth * index + tabbarWidth / 2 + size.width / 2 - 5, 0, size.width, 16.0);
        redIconInfoLabel.text = badgeStr;
    
        
    }
    
}

- (void)removeBadgeOnItemIndex:(NSInteger)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
