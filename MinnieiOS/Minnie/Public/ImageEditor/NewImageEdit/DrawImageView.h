//
//  DrawImageView.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/22.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DrawImageViewDelegate <NSObject>

- (void)drawImageViewTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)drawImageViewTouchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)drawImageViewTouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

@interface DrawImageView : UIImageView

@property (nonatomic,weak) id<DrawImageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
