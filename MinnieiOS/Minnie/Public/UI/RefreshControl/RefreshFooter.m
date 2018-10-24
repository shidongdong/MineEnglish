//
//  RefreshFooter.m
//  X5
//

#import "RefreshFooter.h"
#import "LoadingIndicatorView.h"

@interface RefreshFooter ()

@property (nonatomic, strong) LoadingIndicatorView *loadingIndicatorView;

@end

@implementation RefreshFooter

#pragma mark - Lazy load

- (LoadingIndicatorView *)loadingIndicatorView
{
    if (!_loadingIndicatorView) {
        _loadingIndicatorView = [[LoadingIndicatorView alloc] init];
        [self addSubview:_loadingIndicatorView];
    }
    return _loadingIndicatorView;
}

#pragma mark - Override

- (void)prepare {
    [super prepare];
    
    self.triggerAutomaticallyRefreshPercent = 0.1;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    self.stateLabel.hidden = NO;
    self.stateLabel.font = [UIFont systemFontOfSize:15];
    self.stateLabel.textColor = [UIColor grayColor];
    
    [self setTitle:@"开始加载" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载..." forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"已无更多数据" forState:MJRefreshStateNoMoreData];
}

- (void)beginRefreshing {
    if (_stopEnterRefreshingState) {
        return;
    }
    
    [super beginRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.loadingIndicatorView.mj_size = CGSizeMake(16, 16);
    
    CGFloat loadingImageViewCenterX = self.mj_w * 0.5 - 55;
    CGFloat loadingImageViewCenterY = self.mj_h * 0.5;
    self.loadingIndicatorView.center = CGPointMake(loadingImageViewCenterX, loadingImageViewCenterY);
    
    if (self.loadingIndicatorView.isHidden) {
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.frame = CGRectMake(0, 0, self.mj_w, self.mj_h);
    } else {
        self.stateLabel.textAlignment = NSTextAlignmentLeft;
        
        CGFloat loadingImageViewMaxX = CGRectGetMaxX(self.loadingIndicatorView.frame);
        CGFloat spacingBetweenLoadingImageAndStateLabel = 8;
        CGFloat stateLabelW = self.mj_w - loadingImageViewMaxX - spacingBetweenLoadingImageAndStateLabel;
        self.stateLabel.mj_size = CGSizeMake(stateLabelW, self.mj_h);
        
        CGFloat stateLabelX = loadingImageViewMaxX + spacingBetweenLoadingImageAndStateLabel;
        self.stateLabel.mj_origin = CGPointMake(stateLabelX, 0);
    }
}

- (void)setState:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self stopLoading];
            break;
        }
        case MJRefreshStatePulling:
        {
            [self startLoading];
            break;
        }
        case MJRefreshStateWillRefresh:
        {
            [self startLoading];
            break;
        }
        case MJRefreshStateRefreshing:
        {
            [self startLoading];
            break;
        }
        case MJRefreshStateNoMoreData:
        {
            [self stopLoading];
            break;
        }
    }
    
    [super setState:state];
}

#pragma mark - Private

- (void)startLoading
{
    self.loadingIndicatorView.hidden = NO;
    if (![self.loadingIndicatorView isAnimating]) {
        [self.loadingIndicatorView startAnimating];
    }
}

- (void)stopLoading
{
    self.loadingIndicatorView.hidden = YES;
    if ([self.loadingIndicatorView isAnimating]) {
        [self.loadingIndicatorView stopAnimating];
    }
}

@end
