//
//  RefreshHeader.m
//  X5
//

#import "RefreshHeader.h"

@interface RefreshHeader ()
@end

@implementation RefreshHeader

#pragma mark - Override

- (void)beginRefreshing
{
    if (_stopEnterRefreshingState) {
        return;
    }
    
    [super beginRefreshing];
}

- (void)prepare
{
    [super prepare];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    [self setImages:@[[UIImage imageNamed:@"加载动画01"]] forState:MJRefreshStateIdle];
    [self setImages:@[[UIImage imageNamed:@"加载动画01"]] forState:MJRefreshStatePulling];
    [self setImages:@[[UIImage imageNamed:@"加载动画01"]] forState:MJRefreshStateWillRefresh];
    
    NSMutableArray *refreshImages = [NSMutableArray array];
    for (NSInteger i = 0; i<5; i++) {
        UIImage *refreshImage = [UIImage imageNamed:[NSString stringWithFormat:@"加载动画0%zd", i+1]];
        if (refreshImage != nil) {
            [refreshImages addObject:refreshImage];
        }
    }
    [self setImages:refreshImages forState:MJRefreshStateRefreshing];
}

#pragma mark - override method

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    if (self.state == MJRefreshStateNoMoreData) {
        return;
    }
    
    [super scrollViewPanStateDidChange:change];
}

@end

