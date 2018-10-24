//
//  MaskImageView.h
//  X5
//
//  Created by yebw on 2017/10/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskImageView : UIImageView

- (void)fitShapeWithMaskImage:(UIImage *)maskImage
                  topCapInset:(CGFloat)topCapInset
                 leftCapInset:(CGFloat)leftCapInset
                         size:(CGSize)size;

@end

