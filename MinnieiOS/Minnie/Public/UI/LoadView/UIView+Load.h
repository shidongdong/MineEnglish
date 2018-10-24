//
//  UIView+Load.h
//
//  Created by yebingwei on 2017/7/19.
//

#import <UIKit/UIKit.h>

typedef void (^LoadViewRetryCallback)(void);
typedef void (^LoadViewLinkClickCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIView(Load)

#pragma mark - 加载

/**
 显示加载态视图(转圈动画), 转圈视图在垂直方向居中
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 */
- (void)showLoadingView;

/**
 显示加载态视图(转圈动画)
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param offset 加载态视图元素居中约束的偏移值, 向上是负数, 向下是正数, 零相当于完全居中
 */
- (void)showLoadingViewWithCenterYOffset:(CGFloat)offset;

/**
 隐藏加载态视图
 */
- (void)hideLoadingView;

#pragma mark - 失败

/**
 显示加载失败视图, 内容元素垂直方向居中向上偏移kDefaultCenterYOffsetOfLoadView(-50)高度
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param retryCallback 重试点击回调
 
 */
- (void)showFailureViewWithRetryCallback:(LoadViewRetryCallback)retryCallback;

/**
 显示加载失败视图
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param offset 加载态视图元素居中约束的偏移值, 向上是负数, 向下是正数, 零相当于完全居中
 @param retryCallback 重试点击回调
 */
- (void)showFailureViewWithCenterYOffset:(CGFloat)offset
                           retryCallback:(LoadViewRetryCallback)retryCallback;

/**
 显示加载失败视图, 内容元素垂直方向居中向上偏移kDefaultCenterYOffsetOfLoadView(-50)高度
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param image 错误图
 @param title 错误提示
 @param retryCallback 重试点击回调
 @param linkTitle 链接提示文本（如 “查看解决方案”）
 @param linkClickCallback 链接点击回调
 */
- (void)showFailureViewWithImage:(nullable UIImage *)image
                           title:(NSString *)title
                   retryCallback:(LoadViewRetryCallback)retryCallback
                       linkTitle:(nullable NSString *)linkTitle
               linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback;

/**
 显示加载失败视图
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param image 错误图
 @param title 错误提示
 @param offset 加载态视图元素居中约束的偏移值, 向上是负数, 向下是正数, 零相当于完全居中
 @param retryCallback 重试点击回调
 @param linkTitle 链接提示文本（如 “查看解决方案”）
 @param linkClickCallback 链接点击回调
 */
- (void)showFailureViewWithImage:(nullable UIImage *)image
                           title:(NSString *)title
                   centerYOffset:(CGFloat)offset
                   retryCallback:(LoadViewRetryCallback)retryCallback
                       linkTitle:(nullable NSString *)linkTitle
               linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback;


/**
 隐藏失败视图
 */
- (void)hideFailureView;

#pragma mark - 空态

/**
 显示空态视图, 内容元素垂直方向居中向上偏移kDefaultCenterYOffsetOfLoadView(-50)高度
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param image 空态图
 @param title 空态提示
 @param linkTitle 链接提示
 @param linkClickCallback 链接点击回调
 */
- (void)showEmptyViewWithImage:(nullable UIImage *)image
                         title:(NSString *)title
                     linkTitle:(nullable NSString *)linkTitle
             linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback;

/**
 显示空态视图
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param image 空态图
 @param title 空态提示
 @param offset 加载态视图元素居中约束的偏移值, 向上是负数, 向下是正数, 零相当于完全居中
 @param linkTitle 链接提示
 @param linkClickCallback 链接点击回调
 */
- (void)showEmptyViewWithImage:(nullable UIImage *)image
                         title:(NSString *)title
                 centerYOffset:(CGFloat)offset
                     linkTitle:(nullable NSString *)linkTitle
             linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback;

/**
 显示空态视图
 注意：调用该函数会自动移除当前视图中的加载失败态视图以及空态视图
 
 @param image 空态图
 @param title 空态提示
 @param offset 加载态视图元素居中约束的偏移值, 向上是负数, 向下是正数, 零相当于完全居中
 @param linkTitle 链接提示
 @param linkClickCallback 链接点击回调
 @param retryCallback 重试点击回调
 */
- (void)showEmptyViewWithImage:(nullable UIImage *)image
                         title:(NSString *)title
                 centerYOffset:(CGFloat)offset
                     linkTitle:(nullable NSString *)linkTitle
             linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback
                 retryCallback:(nullable LoadViewRetryCallback)retryCallback;


/**
 隐藏空态视图
 */
- (void)hideEmptyView;

#pragma mark - 移除所有状态的视图

/**
 隐藏所有状态的视图，一般可以用在开始显示数据的时候
 */
- (void)hideAllStateView;


#pragma mark - 修改视图位置

/**
 改变已经存在的状态页面视图的偏移值
 
 @param offsetY 约束的偏移值, 向上是负数, 向下是正数, 零相当于完全居中
 */
- (void)changeStateViewCenterYOffset:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END

