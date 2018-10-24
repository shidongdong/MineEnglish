//
//  LoadingIndicatorView.m
//
//  Created by yebingwei on 2017/2/24.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "LoadingIndicatorView.h"
#import <Masonry/Masonry.h>

@interface LoadingIndicatorView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) NSUInteger repeatCount;

@end

@implementation LoadingIndicatorView

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_indicatorView];
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)startAnimating
{
    if (self.isAnimating) {
        return;
    }
    
    _isAnimating = YES;
    [_indicatorView startAnimating];
}

- (void)stopAnimating
{
    if (!self.isAnimating) {
        return;
    }
    
    _isAnimating = NO;
    [_indicatorView stopAnimating];
}

- (void)dealloc
{
    [self stopAnimating];
}

@end
