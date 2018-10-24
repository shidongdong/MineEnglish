//
//  UIScrollView+Refresh.h
//  X5
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)

#pragma mark - 下拉刷新

/**
 *  添加下拉刷新控件
 *
 *  进入刷新状态就会自动调用target对象的action方法
 *
 */
- (void)addPullToRefreshWithTarget:(id)target refreshingAction:(SEL)action;

/**
 *  添加下拉刷新控件
 *
 *  @param block 进入刷新状态就会自动调用block
 */
- (void)addPullToRefreshWithRefreshingBlock:(void (^)(void))block;

#pragma mark - 上拉加载更多

/**
 *  添加一个上拉加载更多控件
 *
 *  进入刷新状态就会自动调用target对象的action方法
 *
 */
- (void)addInfiniteScrollingWithTarget:(id)target refreshingAction:(SEL)action;

/**
 *  添加一个上拉加载更多控件
 *
 *  @param block 进入刷新状态就会自动调用block
 *
 */
- (void)addInfiniteScrollingWithRefreshingBlock:(void (^)(void))block;

#pragma mark - 下拉加载更多

/**
 *  添加下拉加载更多控件
 *
 *  进入刷新状态就会自动调用target对象的action方法
 */
- (void)addPullToLoadMoreWithTarget:(id)target refreshingAction:(SEL)action;

#pragma mark - Header & Footer

/**
 *  移除header
 */
- (void)removeHeader;

/**
 *  移除footer
 */
- (void)removeFooter;

/**
 *  header是否存在
 */
- (BOOL)isHeaderExist;

/**
 *  footer是否存在
 */
- (BOOL)isFooterExist;

/**
 *  手动使header进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  手动使header结束刷新状态
 */
- (void)headerEndRefreshing;

/**
 *  header是否在刷新状态
 */
- (BOOL)isHeaderRefreshing;

/**
 *  手动使footer进入刷新状态
 */
- (void)footerBeginRefreshing;

/**
 *  手动使footer结束刷新状态
 */
- (void)footerEndRefreshing;

/**
 *  footer是否在刷新状态
 */
- (BOOL)isFooterRefreshing;

/**
 *  footer提示没有更多的数据
 */
- (void)footerNoticeNoMoreData;

/**
 header用指定文案提示没有更多数据

 @param text 提示文案
 */
- (void)headerNoticeNoMoreDataWithText:(NSString *)text;

/**
 footer用指定文案提示没有更多数据

 @param text 提示文案
 */
- (void)footerNoticeNoMoreDataWithText:(NSString *)text;

/**
 *  footer重置状态（消除“没有更多数据”的提示）
 */
- (void)footerResetNoMoreData;

- (void)setFooterHidden:(BOOL)footerHidden;

- (void)setHeaderHidden:(BOOL)headerHidden;

@end
