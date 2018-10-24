//
//  MaskImageView.m
//  X5
//
//  Created by yebw on 2017/10/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "MaskImageView.h"

@interface MaskImageView()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation MaskImageView

- (void)fitShapeWithMaskImage:(UIImage *)maskImage
                  topCapInset:(CGFloat)topCapInset
                 leftCapInset:(CGFloat)leftCapInset
                         size:(CGSize)size {
    if (self.maskLayer == nil) {
        self.maskLayer = [[CAShapeLayer alloc] init];
        self.maskLayer.contentsScale = [UIScreen mainScreen].scale;
        self.maskLayer.contentsCenter = CGRectMake(leftCapInset/maskImage.size.width,
                                                   topCapInset/maskImage.size.height,
                                                   1.0/maskImage.size.width,
                                                   1.0/maskImage.size.height);
        self.maskLayer.frame = CGRectMake(0, 0, size.width, size.height);
        self.maskLayer.contents = (__bridge id)(maskImage.CGImage);
        
        self.layer.mask = self.maskLayer;
        self.layer.masksToBounds = YES;
    }
}

@end
