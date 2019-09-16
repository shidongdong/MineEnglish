//
//  MIToastView.h
//  Minnie
//
//  Created by songzhen on 2019/8/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIToastView : UIView

+ (void)setTitle:(NSString *)title
         confirm:(NSString *)confirm
          cancel:(NSString *)cancel
       superView:(UIView *)superView
    confirmBlock:(void (^)(void))confirmBlock
     cancelBlock:(void (^)(void))cancelBlock;


@end

NS_ASSUME_NONNULL_END
