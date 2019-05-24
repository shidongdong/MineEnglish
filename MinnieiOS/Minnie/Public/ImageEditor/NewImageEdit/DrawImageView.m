//
//  DrawImageView.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/22.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "DrawImageView.h"

@interface DrawImageView ()

@end

@implementation DrawImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
      
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.delegate && [self.delegate respondsToSelector:@selector(drawImageViewTouchesBegan:withEvent:)]) {
        
        [self.delegate drawImageViewTouchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawImageViewTouchesMoved:withEvent:)]) {
        
        [self.delegate drawImageViewTouchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawImageViewTouchesEnded:withEvent:)]) {
        
        [self.delegate drawImageViewTouchesEnded:touches withEvent:event];
    }
}

@end
