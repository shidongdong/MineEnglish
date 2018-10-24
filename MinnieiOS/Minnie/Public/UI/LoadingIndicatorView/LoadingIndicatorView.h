//
//  LoadingIndicatorView.h
//  SlideDemo
//
//  Created by yebingwei on 2017/2/24.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingIndicatorView : UIView

@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimating;

- (void)stopAnimating;

@end
