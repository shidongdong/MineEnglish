//
//  NEPhotoBrowserView.h
//  NECatoonReader
//
//  Created by hubo on 2017/1/18.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLAnimatedImageView;

@interface NEPhotoBrowserView : UIView

/**
 当前图片imageView
 */
@property (strong, nonatomic) FLAnimatedImageView *imageView;

/**
 是否全屏显示图片，YES:全屏显示，NO：按照默认规则显示，默认为NO
 */
@property (assign, nonatomic) BOOL isScaleToScreenWidth;

/**
 是否隐藏图片加载indicator，YES:隐藏, NO:显示
 */
@property (assign, nonatomic) BOOL hideLoadingView;

/**
 图片是否有加载成功，YES:加载成功，NO:加载失败
 */
@property (readonly, nonatomic) BOOL isHadLoadedImage;

/**
 图片单击点击block回调
 */
@property (strong, nonatomic) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

/**
 加载图片

 @param url 图片URL
 @param placeholder 图片placeholder
 */
- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;


/**
 还原ImageView zoomScale
 */
- (void)resetImageView;

@end
