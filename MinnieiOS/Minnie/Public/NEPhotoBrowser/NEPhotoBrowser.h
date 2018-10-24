//
//  NEPhotoBrowser.h
//  NECatoonReader
//
//  Created by hubo on 15/9/13.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NEPhotoBrowser;
@class NEPhotoBrowserView;

#pragma mark - NEPhotoBrowserDataSource

@protocol NEPhotoBrowserDataSource <NSObject>

@required

/**
 图片浏览器图片的个数

 @param browser 当前图片浏览器
 @return 返回图片个数
 */
- (NSInteger)numberOfPhotosInPhotoBrowser:(NEPhotoBrowser *)browser;

/**
 当前图片URL

 @param browser 当前图片浏览器
 @param index 当前图片index，index从0开始
 @return 返回index对应的图片URL
 */
- (NSURL* __nonnull)photoBrowser:(NEPhotoBrowser * __nonnull)browser imageURLForIndex:(NSInteger)index;

// 当前图片加载placeholder

/**
 当前图片placeHolder

 @param browser 当前图片浏览器
 @param index 当前图片index，index从0开始
 @return 当前图片placeHolder图片
 */
- (UIImage * __nullable)photoBrowser:(NEPhotoBrowser * __nonnull)browser placeholderImageForIndex:(NSInteger)index;

@end

#pragma mark - NEPhotoBrowserDelegate

@protocol NEPhotoBrowserDelegate<NSObject>

@optional

/**
 图片保存到相册中

 @param browser 当前图片浏览器
 @param view 当前图片视图
 */
- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser willSavePhotoWithView:(NEPhotoBrowserView *)view;

/**
 图片保存到相册成功

 @param browser 当前图片浏览器
 @param image 当前保存的图片
 */
- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser didSavePhotoSuccessWithImage:(UIImage *)image;

/**
 图片保存到相册失败

 @param browser 当前图片浏览器
 @param error 错误码
 */
- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser savePhotoErrorWithError:(NSError *)error;

/**
 切换到index对应的图片

 @param browser 当前图片浏览器
 @param index 当前图片index
 */
- (void)photoBrowser:(NEPhotoBrowser * __nonnull)browser scrollToIndex:(NSUInteger)index;

@end

#pragma mark - NEPhotoBrowser

@interface NEPhotoBrowser : UIViewController

@property (weak, nonatomic) id<NEPhotoBrowserDataSource> dataSource;
@property (weak, nonatomic) id<NEPhotoBrowserDelegate> delegate;

/**
 当前点击的imageView，必须传
 */
@property (weak, nonatomic) UIImageView *clickedImageView;

/**
 当前点击图片的containerView
 可空，imageViewsContainerView的subviews为imageview类型或者imageViewsContainerView为UICollectionView
 */
@property (weak, nonatomic) UIView *imageViewsContainerView;

/**
 当前点击图片的index，默认为0
 */
@property (assign, nonatomic) NSUInteger clickedImageIndex;

/**
 当前点击图片的rect，可空，一般情况下不用传，除非当前rect无法计算（比如supverView为webview）
 */
@property (assign, nonatomic) CGRect clickedImageViewRect;

/**
 是否全屏显示图片，YES:全屏显示，NO：按照默认规则显示，默认为NO
 */
@property (assign, nonatomic) BOOL isScaleToScreenWidth;

/**
 动画显示图片浏览器
 */
- (void)showInContext:(UIViewController * __nonnull)context;

#pragma mrak Custom UI

/**
 图片浏览器背景色
 */
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 隐藏保存图片按钮，YES:隐藏，NO:显示
 */
@property (assign, nonatomic) BOOL hiddenSaveImageButton;

/**
 隐藏index Label，YES:隐藏，NO:显示
 */
@property (assign, nonatomic) BOOL hiddenIndexLabel;

/**
 保存图片按钮的图片普通态
 */
@property (strong, nonatomic) UIImage *saveImageForNormal;

/**
 保存图片按钮的图片点击态
 */
@property (strong, nonatomic) UIImage *saveImageForHighlight;

/**
 index label text color
 */
@property (strong, nonatomic) UIColor *indexLabelTextColor;

/**
 index label 当前index text color
 */
@property (strong, nonatomic) UIColor *indexLabelTextColorForCurrent;

/**
 index label text font
 */
@property (strong, nonatomic) UIFont *indexLabelFont;

/**
 index label 当前index text font
 */
@property (strong, nonatomic) UIFont *indexLabelFontForCurrent;

@end

NS_ASSUME_NONNULL_END
