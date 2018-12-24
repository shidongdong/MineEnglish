//
//  UITabBar+KSBadge.h
//
//  Created by 栋栋 施 on 17/1/9.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (KSBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index totalTabbarCount:(NSInteger)total withInfo:(NSInteger)count;   //显示小红点

- (void)removeBadgeOnItemIndex:(NSInteger)index; //隐藏小红点

@end
