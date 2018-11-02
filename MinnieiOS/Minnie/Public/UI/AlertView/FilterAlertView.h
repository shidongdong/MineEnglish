//
//  FilterAlertView.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/1.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FliterAlertActionCallback)(NSInteger index);

@interface FilterAlertView : UIView

+ (instancetype)showInView:(UIView *)superView atFliterType:(NSInteger)index forBgViewOffset:(CGFloat)offset withAtionBlock:(FliterAlertActionCallback)block;

@end
