//
//  UIScrollView+Refresh.m
//  X5
//

#import "UIScrollView+Refresh.h"
#import "ChatRefreshHeader.h"
#import "RefreshHeader.h"
#import "RefreshFooter.h"
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)

#pragma mark - 下拉刷新

- (void)addPullToRefreshWithTarget:(id)target refreshingAction:(SEL)action
{
    RefreshHeader *header = [self addHeader];
    header.refreshingTarget = target;
    header.refreshingAction = action;
}

- (void)addPullToRefreshWithRefreshingBlock:(void (^)(void))block
{
    RefreshHeader *header = [self addHeader];
    header.refreshingBlock = block;
}

#pragma mark - 上拉加载

- (void)addInfiniteScrollingWithTarget:(id)target refreshingAction:(SEL)action
{
    RefreshFooter *footer = [self addFooter];
    footer.refreshingTarget = target;
    footer.refreshingAction = action;
}

- (void)addInfiniteScrollingWithRefreshingBlock:(void (^)(void))block
{
    RefreshFooter *footer = [self addFooter];
    footer.refreshingBlock = block;
}

#pragma mark - 下拉加载

- (void)addPullToLoadMoreWithTarget:(id)target refreshingAction:(SEL)action
{
    RefreshHeader *header = [self addPullToLoadMoreHeader];
    header.refreshingTarget = target;
    header.refreshingAction = action;
}

#pragma mark - header

- (RefreshHeader *)addHeader
{
    if (self.mj_header) {
        [self removeObserverForHeader];
    }
    
    RefreshHeader *header = [[RefreshHeader alloc] init];
    self.mj_header = header;
    [self addObserverForHeader];
    return header;
}

- (RefreshHeader *)addPullToLoadMoreHeader
{
    if (self.mj_header) {
        [self removeObserverForHeader];
    }
    
    ChatRefreshHeader *header = [[ChatRefreshHeader alloc] init];
    self.mj_header = header;
    [self addObserverForHeader];
    return header;
}

- (void)removeHeader
{
    [self removeObserverForHeader];
    self.mj_header = nil;
}

- (BOOL)isHeaderExist
{
    return (self.mj_header != nil);
}

#pragma mark - footer

- (RefreshFooter *)addFooter
{
    if (self.mj_footer) {
        [self removeObserverForFooter];
    }
    
    RefreshFooter *footer = [[RefreshFooter alloc] init];
    self.mj_footer = footer;
    [self addObserverForFooter];
    return footer;
}

- (void)removeFooter
{
    [self removeObserverForFooter];
    self.mj_footer = nil;
}

- (BOOL)isFooterExist
{
    return (self.mj_footer != nil);
}

#pragma mark - KVO

- (void)addObserverForHeader
{
//    [self.mj_header addObserver:self forKeyPath:MJRefreshKeyPathPanState options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForHeader
{
//    [self.mj_header removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
}

- (void)addObserverForFooter
{
//    [self.mj_footer addObserver:self forKeyPath:MJRefreshKeyPathPanState options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForFooter
{
//    [self.mj_footer removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
}

#pragma mark - swizzle

+ (void)load
{
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(deallocSwizzle));
    method_exchangeImplementations(method1, method2);
}

- (void)deallocSwizzle
{
    [self removeFooter];
    [self removeHeader];
    
    [self deallocSwizzle];
}

#pragma mark - refresh

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

/**
 *  控制下拉刷新头部控件的可见性
 */
- (void)setHeaderHidden:(BOOL)headerHidden
{
    self.mj_header.hidden = headerHidden;
}

- (BOOL)isHeaderHidden
{
    return self.mj_header.isHidden;
}

/**
 *  是否正在下拉刷新
 */
- (BOOL)isHeaderRefreshing
{
    return self.mj_header.isRefreshing;
}

#pragma mark - load more

/**
 *  主动让上拉加载尾部控件进入刷新状态
 */
- (void)footerBeginRefreshing
{
    [self.mj_footer beginRefreshing];
}

/**
 *  让上拉加载尾部控件停止刷新状态
 */
- (void)footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

/**
 *  上拉加载头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)footerHidden
{
    self.mj_footer.hidden = footerHidden;
}

- (BOOL)isFooterHidden
{
    return self.mj_footer.isHidden;
}

/**
 *  是否正在上拉加载
 */
- (BOOL)isFooterRefreshing
{
    return self.mj_footer.isRefreshing;
}

- (void)footerNoticeNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)headerNoticeNoMoreDataWithText:(NSString *)text {
    RefreshHeader *header = [self addHeader];
    [header setState:MJRefreshStateNoMoreData];
    [header setTitle:text forState:MJRefreshStateNoMoreData];
}

- (void)footerNoticeNoMoreDataWithText:(NSString *)text {
    if ([self.mj_footer isKindOfClass:[RefreshFooter class]]) {
        [(RefreshFooter *)self.mj_footer setTitle:text forState:MJRefreshStateNoMoreData];
    }
    
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)footerResetNoMoreData
{
    [self.mj_footer resetNoMoreData];
}

@end
