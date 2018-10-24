//
//  TIP.h
//
//  Created by yebw on 14/12/22.
//

#import <UIKit/UIKit.h>

@interface TIP : UIView

+ (void)showText:(NSString *)text inView:(UIView *)view withTopOffset:(CGFloat)offset andDuration:(CGFloat)duration;

+ (void)showText:(NSString *)text inView:(UIView *)view withTopOffset:(CGFloat)offset;

+ (void)showText:(NSString *)text inView:(UIView *)view withBottomOffset:(CGFloat)offset andDuration:(CGFloat)duration;

+ (void)showText:(NSString *)text inView:(UIView *)view withBottomOffset:(CGFloat)offset;

+ (void)showText:(NSString *)text inView:(UIView *)view withDuration:(CGFloat)duration;

+ (void)showText:(NSString *)text inView:(UIView *)view;

+ (void)showImage:(UIImage *)image inView:(UIView *)view withDuration:(CGFloat)duration withOffset:(CGFloat)offset;

+ (void)showProgressWithText:(NSString *)text inView:(UIView *)view;

+ (void)hideAnimated:(BOOL)animated;

@end
