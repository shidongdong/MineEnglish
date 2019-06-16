//
//  MIRecordWaveView.m
//  Minnie
//
//  Created by songzhen on 2019/6/16.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIRecordWaveView.h"

@interface MIRecordWaveView (){
    
    CAShapeLayer *shaper;
    CAShapeLayer *shaper1;
    CAShapeLayer *shaper2;
    
    CGFloat _viewWidth;
    CGFloat _viewHeight;
    CADisplayLink *_displayLink;
}

@end

@implementation MIRecordWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"正在录制";
        titleLabel.textColor = [UIColor normalColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:titleLabel];
        titleLabel.frame = CGRectMake(0, 10, frame.size.width, 20);
    }
    return self;
}

- (void) startRecordAnimation{
    
    [self shaperLayer];
}

- (void) stopRecordAnimation{
    [_displayLink invalidate];
    _displayLink = nil;
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void) shaperLayer{
    
    if (!shaper2) {
     
        shaper2 = [[CAShapeLayer alloc] init];
        shaper2.fillColor = [UIColor clearColor].CGColor;
        shaper2.strokeColor = [UIColor mainColor].CGColor;
    }
    shaper2.frame = CGRectMake(0, _viewHeight - 60, _viewWidth, 60);
    [self.layer addSublayer:shaper2];
    
    if (!shaper1) {
        
        shaper1 = [[CAShapeLayer alloc] init];
        shaper1.fillColor = [UIColor clearColor].CGColor;
        shaper1.strokeColor = [UIColor mainColor].CGColor;
    }
    shaper1.frame = shaper2.frame;
    [self.layer addSublayer:shaper1];
    
    if (!shaper) {
        
        shaper = [[CAShapeLayer alloc] init];
        shaper.fillColor = [UIColor clearColor].CGColor;
        shaper.strokeColor = [UIColor mainColor].CGColor;
    }
    shaper.frame = shaper2.frame;
    [self.layer addSublayer:shaper];
    
    if (!_displayLink) {
      
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(draePath)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)draePath{
    
    static  CGFloat i = 0;
    CGFloat A = 20.f;//A振幅
    CGFloat h = 0;//y轴偏移
    CGFloat ω = 0.02;//角速度ω变大，则波形在X轴上收缩（波形变紧密）；角速度ω变小，则波形在X轴上延展（波形变稀疏）。不等于0
    CGFloat φ = 0 - i;//初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
 
    for (int i = 0; i < _viewWidth; i ++) {
        CGFloat x = i;
        CGFloat y = A * sin(ω*x+φ - M_PI)+h;
        CGFloat y1 = A*2/3 * sin(ω*x+φ - M_PI/2.0)+h;
        CGFloat y2 = A*1/3 * sin(ω*x+φ - M_PI/2.0)+h;
        if (i == 0) {
        
            [path moveToPoint:CGPointMake(x, y)];
            [path1 moveToPoint:CGPointMake(x, y1)];
            [path2 moveToPoint:CGPointMake(x, y2)];
        } else {
          
            [path addLineToPoint:CGPointMake(x, y)];
            [path1 addLineToPoint:CGPointMake(x, y1)];
            [path2 addLineToPoint:CGPointMake(x, y2)];
        }
    }
    
    path.lineWidth = 1;
    shaper.path = path.CGPath;
    path1.lineWidth = 1;
    shaper1.path = path1.CGPath;
    path2.lineWidth = 1;
    shaper2.path = path2.CGPath;
    i += 0.1;
    if (i > M_PI * 2) {
        i = 0;//防止i越界
    }
}

@end
