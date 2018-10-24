//
//  SegmentControl.h
//  X5
//
//  Created by yebw on 2017/9/10.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IndexChangeHandler)(NSUInteger selectedIndex);

// 暂仅支持两个tab
@interface SegmentControl : UIView

@property (nonatomic, copy) IndexChangeHandler indexChangeHandler;

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (void)setPersent:(CGFloat)persent;

@end
