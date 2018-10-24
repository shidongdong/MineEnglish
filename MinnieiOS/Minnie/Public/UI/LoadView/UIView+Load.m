//
//  UIView+Load.m
//
//  Created by yebingwei on 2017/7/19.
//

#import "UIView+Load.h"
#import "LoadingIndicatorView.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

const NSUInteger kTagOfLoadingView = 201707190;
const NSUInteger kTagOfSRFailureView = 201707191;
const NSUInteger kTagOfSREmptyView = 201707192;

const CGFloat kDefaultCenterYOffsetOfLoadView = -50.f;

static const char kKeyOfFailureRetryCallback;
static const char kKeyOfFailureLinkClickCallback;
static const char kKeyOfEmptyLinkClickCallback;

@implementation UIView(Load)

#pragma mark - Public

- (void)showLoadingView {
    [self showLoadingViewWithCenterYOffset:0];
}

- (void)showLoadingViewWithCenterYOffset:(CGFloat)offset {
    [self hideAllStateView];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectZero];
    loadingView.tag = kTagOfLoadingView;
    
    [self addSubview:loadingView];
    
    UIImageView *loadingImageView = [[UIImageView alloc] init];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i=1; i<=5; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"加载动画0%zd@2x", i]]];
    }
    [loadingImageView setAnimationImages:images];
    [loadingImageView setAnimationRepeatCount:0];
    [loadingImageView setAnimationDuration:0.5];
    [loadingImageView startAnimating];
    
    [loadingView addSubview:loadingImageView];
    [loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.top.equalTo(loadingView);
        make.centerX.equalTo(loadingView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"正在加载...";
    label.numberOfLines = 1;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor colorWithRed:0x99/255.f green:0x99/255.f blue:0x99/255.f alpha:1.f];
    
    [loadingView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loadingImageView.mas_bottom).with.offset(15);
        make.centerX.equalTo(loadingView);
        make.bottom.equalTo(loadingView);
    }];
    
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.greaterThanOrEqualTo(self).with.offset(0);
        make.centerY.equalTo(self).with.offset(offset).with.priorityMedium();
    }];
}

- (void)hideLoadingView {
    [self removeSubviewWithTag:kTagOfLoadingView];
}

- (void)showFailureViewWithRetryCallback:(LoadViewRetryCallback)retryCallback {
    [self showFailureViewWithImage:nil
                             title:@"加载失败\n点击屏幕重新加载"
                     centerYOffset:kDefaultCenterYOffsetOfLoadView
                     retryCallback:retryCallback
                         linkTitle:nil
                 linkClickCallback:nil];
}

- (void)showFailureViewWithCenterYOffset:(CGFloat)offset
                           retryCallback:(LoadViewRetryCallback)retryCallback {
    [self showFailureViewWithImage:nil
                             title:@"加载失败\n点击屏幕重新加载"
                     centerYOffset:offset
                     retryCallback:retryCallback
                         linkTitle:nil
                 linkClickCallback:nil];
}

- (void)showFailureViewWithImage:(UIImage *)image
                           title:(NSString *)title
                   retryCallback:(LoadViewRetryCallback)retryCallback
                       linkTitle:(nullable NSString *)linkTitle
               linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback {
    [self showFailureViewWithImage:image
                             title:title
                     centerYOffset:kDefaultCenterYOffsetOfLoadView
                     retryCallback:retryCallback
                         linkTitle:linkTitle
                 linkClickCallback:linkClickCallback];
}

- (void)showFailureViewWithImage:(UIImage *)image
                           title:(NSString *)title
                   centerYOffset:(CGFloat)offset
                   retryCallback:(LoadViewRetryCallback)retryCallback
                       linkTitle:(nullable NSString *)linkTitle
               linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback {
    [self hideAllStateView];
    
    UIView *failureView = [[UIView alloc] init];
    failureView.backgroundColor = [UIColor clearColor];
    failureView.tag = kTagOfSRFailureView;
    
    [self addSubview:failureView];
    [failureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retryButton.backgroundColor = [UIColor clearColor];
    [self setFailureRetryCallback:retryCallback];
    [retryButton addTarget:self action:@selector(failureRetry) forControlEvents:UIControlEventTouchUpInside];
    [failureView addSubview:retryButton];
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(failureView);
    }];
    
    UIView *failureContentView = [[UIView alloc] init];
    failureContentView.backgroundColor = [UIColor clearColor];
    failureContentView.userInteractionEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [failureContentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(failureContentView);
        make.top.equalTo(failureContentView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor colorWithRed:0x99/255.f green:0x99/255.f blue:0x99/255.f alpha:1.f];
    
    [failureContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(40);
        make.centerX.equalTo(failureContentView);
    }];
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    linkButton.hidden = (linkTitle.length==0);
    [self setFailureLinkClickCallback:linkClickCallback];
    [linkButton addTarget:self action:@selector(failureLinkClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    linkAttributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    linkAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14.f];
    
    NSMutableDictionary *highlightlinkAttributes = [NSMutableDictionary dictionary];
    highlightlinkAttributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    highlightlinkAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14.f];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:linkTitle.length>0?linkTitle:@"不可见"
                                                                                         attributes:linkAttributes];
    NSMutableAttributedString *highlightAttributedString = [[NSMutableAttributedString alloc] initWithString:linkTitle.length>0?linkTitle:@"不可见"
                                                                                                  attributes:highlightlinkAttributes];
    
    [linkButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [linkButton setAttributedTitle:highlightAttributedString forState:UIControlStateHighlighted];
    
    [failureContentView addSubview:linkButton];
    [linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label).with.offset(20);
        make.centerX.equalTo(failureContentView);
        make.bottom.equalTo(failureContentView);
    }];
    
    [failureView addSubview:failureContentView];
    
    CGSize size = [failureContentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [failureContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
        make.width.equalTo(failureView);
        make.centerX.equalTo(failureView);
        make.top.greaterThanOrEqualTo(self).with.offset(0);
        make.centerY.equalTo(failureView).with.offset(offset).with.priorityMedium();
    }];
}

- (void)hideFailureView {
    [self removeSubviewWithTag:kTagOfSRFailureView];
}

- (void)showEmptyViewWithImage:(UIImage *)image
                         title:(NSString *)title
                     linkTitle:(nullable NSString *)linkTitle
             linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback {
    [self showEmptyViewWithImage:image
                           title:title
                   centerYOffset:kDefaultCenterYOffsetOfLoadView
                       linkTitle:linkTitle
               linkClickCallback:linkClickCallback];
}

- (void)showEmptyViewWithImage:(UIImage *)image
                         title:(NSString *)title
                 centerYOffset:(CGFloat)offset
                     linkTitle:(nullable NSString *)linkTitle
             linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback {
    [self showEmptyViewWithImage:image
                           title:title
                   centerYOffset:offset
                       linkTitle:linkTitle
               linkClickCallback:linkClickCallback
                   retryCallback:nil];
}

- (void)showEmptyViewWithImage:(nullable UIImage *)image
                         title:(NSString *)title
                 centerYOffset:(CGFloat)offset
                     linkTitle:(nullable NSString *)linkTitle
             linkClickCallback:(nullable LoadViewLinkClickCallback)linkClickCallback
                 retryCallback:(nullable LoadViewRetryCallback)retryCallback {
    [self hideAllStateView];
    
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = [UIColor clearColor];
    emptyView.tag = kTagOfSREmptyView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [emptyView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.top.equalTo(emptyView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor colorWithRed:0x99/255.f green:0x99/255.f blue:0x99/255.f alpha:1.f];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = 6;
    paragrahStyle.alignment = NSTextAlignmentCenter;
    paragrahStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragrahStyle};
    label.attributedText = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
    
    [emptyView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(30);
        make.centerX.equalTo(emptyView);
    }];
    
    UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    linkButton.hidden = (linkTitle.length==0);
    
    [self setEmptyLinkClickCallback:linkClickCallback];
    [linkButton addTarget:self action:@selector(emptyLinkClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
    linkAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x0098FE];
    linkAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14.f];
    linkAttributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    linkAttributes[NSUnderlineColorAttributeName] = [UIColor colorWithHex:0x0098FE];
    
    NSMutableDictionary *highlightlinkAttributes = [NSMutableDictionary dictionary];
    highlightlinkAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x0098FE];
    highlightlinkAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:14.f];
    highlightlinkAttributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    highlightlinkAttributes[NSUnderlineColorAttributeName] = [UIColor colorWithHex:0x0098FE];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:linkTitle.length>0?linkTitle:@"不可见"
                                                                                         attributes:linkAttributes];
    NSMutableAttributedString *highlightAttributedString = [[NSMutableAttributedString alloc] initWithString:linkTitle.length>0?linkTitle:@"不可见"
                                                                                                  attributes:highlightlinkAttributes];
    
    [linkButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [linkButton setAttributedTitle:highlightAttributedString forState:UIControlStateHighlighted];
    
    [emptyView addSubview:linkButton];
    [linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label).with.offset(30);
        make.centerX.equalTo(emptyView);
        make.bottom.equalTo(emptyView);
    }];
    
    [self addSubview:emptyView];
    
    if (retryCallback != nil) {
        UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emptyView addSubview:retryButton];
        [retryButton setBackgroundColor:[UIColor clearColor]];

        [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(emptyView);
        }];

        [self setFailureRetryCallback:retryCallback];
        [retryButton addTarget:self action:@selector(failureRetry) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGSize size = [emptyView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.greaterThanOrEqualTo(self).with.offset(0);
        make.centerY.equalTo(self).with.offset(offset).with.priorityMedium();
    }];
}

- (void)hideEmptyView {
    [self removeSubviewWithTag:kTagOfSREmptyView];
}

- (void)hideAllStateView {
    [self hideLoadingView];
    [self hideFailureView];
    [self hideEmptyView];
}

- (void)changeStateViewCenterYOffset:(CGFloat)offsetY {
    [self changeStautsViewWithTag:kTagOfSREmptyView andCenterYOffsetTo:offsetY];
    [self changeStautsViewWithTag:kTagOfSRFailureView andCenterYOffsetTo:offsetY];
    [self changeStautsViewWithTag:kTagOfLoadingView andCenterYOffsetTo:offsetY];
}

#pragma mark - Private

- (void)changeStautsViewWithTag:(NSInteger)tag andCenterYOffsetTo:(CGFloat)offsetY {
    UIView *v = nil;
    for (UIView *sub in self.subviews) {
        if (sub.tag == tag) {
            v = sub;
            break;
        }
    }
    [v mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(offsetY).with.priorityMedium();
    }];
}

- (void)removeSubviewWithTag:(NSInteger)tag {
    UIView *v = nil;
    for (UIView *sub in self.subviews) {
        if (sub.tag == tag) {
            v = sub;
            break;
        }
    }
    
    [v removeFromSuperview];
}

- (void)setFailureRetryCallback:(LoadViewRetryCallback)callback {
    if (callback != nil) {
        objc_setAssociatedObject(self, &kKeyOfFailureRetryCallback, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (LoadViewRetryCallback)failureRetryCallback {
    return objc_getAssociatedObject(self, &kKeyOfFailureRetryCallback);
}

- (void)failureRetry {
    LoadViewRetryCallback callback = [self failureRetryCallback];
    if (callback != nil) {
        callback();
    }
}

- (void)setFailureLinkClickCallback:(LoadViewLinkClickCallback)callback {
    if (callback != nil) {
        objc_setAssociatedObject(self, &kKeyOfFailureLinkClickCallback, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (LoadViewLinkClickCallback)failureLinkClickCallback {
    return objc_getAssociatedObject(self, &kKeyOfFailureLinkClickCallback);
}

- (void)failureLinkClick {
    LoadViewLinkClickCallback callback = [self failureLinkClickCallback];
    if (callback != nil) {
        callback();
    }
}

- (void)setEmptyLinkClickCallback:(LoadViewLinkClickCallback)callback {
    if (callback != nil) {
        objc_setAssociatedObject(self, &kKeyOfEmptyLinkClickCallback, callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (LoadViewLinkClickCallback)emptyLinkClickCallback {
    return objc_getAssociatedObject(self, &kKeyOfEmptyLinkClickCallback);
}

- (void)emptyLinkClick {
    LoadViewLinkClickCallback callback = [self emptyLinkClickCallback];
    if (callback != nil) {
        callback();
    }
}

@end

