//
//  NEPhotoIndicatorView.m
//  NECatoonReader
//
//  Created by hubo on 15/9/13.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "NEPhotoIndicatorView.h"

static CGFloat const kIndicatorViewItemMargin = 10.f;

@implementation NEPhotoIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = 42;
    frame.size.height = 42;
    self.layer.cornerRadius = 21;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];

    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - kIndicatorViewItemMargin;

    CGFloat w = radius * 2 + kIndicatorViewItemMargin;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);

    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
    CGContextClosePath(ctx);

    CGContextFillPath(ctx);
}

@end
