//
//  ChatRefreshHeader.m
//  X5
//
//

#import "ChatRefreshHeader.h"

@implementation ChatRefreshHeader

#pragma mark - Override

- (void)prepare
{
    [super prepare];

    [self setTitle:NSLocalizedString(@"ChatRefreshHeaderIdleText", nil) forState:MJRefreshStateIdle];
    [self setTitle:NSLocalizedString(@"ChatRefreshHeaderPullingText", nil) forState:MJRefreshStatePulling];
    [self setTitle:NSLocalizedString(@"ChatRefreshHeaderRefreshingText", nil) forState:MJRefreshStateRefreshing];
}

@end
