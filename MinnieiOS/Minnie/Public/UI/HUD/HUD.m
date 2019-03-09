//
//  HUD.m
//
//  Created by yebw on 13-4-29.
//  Modified by yebw on 16/11/9

#import "HUD.h"

#import <Masonry/Masonry.h>

#define HUD_DEFAULT_DURATION        (2.f)
#define HUD_MIN_SIZE                (CGSizeMake(100.f, 36.f))
#define HUD_MAX_WIDTH               (240.f)
#define HUD_MESSAGE_FONT_SIZE       (14.f)
#define HUD_MARGIN                  (10.f)
#define HUD_PADDING                 (8.f)
#define HUD_CORNER_RADIUS           (4.f)
#define HUD_CANCEL_BUTTON_SIZE      (CGSizeMake(36.f, 36.f))
#define HUD_BACKGROUND_COLOR        ([UIColor colorWithRed:0 green:0 blue:0 alpha:0.7])
#define HUD_CANCEL_BACKGROUND_COLOR ([UIColor colorWithRed:0 green:0 blue:0 alpha:0])

@interface HUDCancelButton : UIButton
@property (nonatomic, copy) HUDCancelCallback cancelCallback;
@end

@implementation HUDCancelButton
@end

@interface HUDIndicatorView : UIView
@property (nonatomic, strong) UIImageView *indicatorImageView;
@end

@implementation HUDIndicatorView

- (id)init {
    self = [super init];
    if (self != nil) {
        _indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_ic_loading"]];
        
        [self addSubview:_indicatorImageView];
        [_indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.indicatorImageView.layer animationForKey:@"rotationAnimation"] == nil) {
        [self startAnimation];
    }
}

- (void)startAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    
    [self.indicatorImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end


@implementation HUD

#pragma mark - Public Methods

+ (void)showWithMessage:(NSString *)message {
    UIWindow *topWindow = [HUD topWindow];
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:topWindow];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:topWindow animated:YES];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    }
    
    hud.mode = MBProgressHUDModeText;
    
    [HUD resetHUD:hud];
    
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.label.text = message;
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:HUD_DEFAULT_DURATION];
}

+ (void)showProgressWithMessage:(NSString *)message {
    [self showProgressWithMessage:message cancelCallback:nil];
}

+ (MBProgressHUD *)showProgressWithMessage:(NSString *)message
                 cancelCallback:(HUDCancelCallback)cancelCallback
{
    UIWindow *topWindow = [HUD topWindow];
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:topWindow];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:topWindow animated:YES];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    
    [HUD resetHUD:hud];
    
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor clearColor];
    
    CGSize size = CGSizeZero;
    
    if (cancelCallback == nil) { // 转圈+文案
        // 1. 错误图标
        HUDIndicatorView *indicatorView = [[HUDIndicatorView alloc] init];
        [customView addSubview:indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.top.equalTo(customView.mas_top).with.offset(HUD_MARGIN);
        }];
        
        CGSize indicatorViewSize = [indicatorView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        // 2. 错误提示
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:HUD_MESSAGE_FONT_SIZE];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 0;
        textLabel.tag = 99;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.preferredMaxLayoutWidth = HUD_MAX_WIDTH;
        textLabel.text = message;
        [customView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.top.equalTo(indicatorView.mas_bottom).with.offset(HUD_PADDING);
        }];
        
        CGSize labelSize = [textLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        size = CGSizeMake(MAX(indicatorViewSize.width, labelSize.width)+2*HUD_MARGIN, indicatorViewSize.height+HUD_PADDING+labelSize.height+2*HUD_MARGIN);
    } else { // 文案加取消按钮
        // 1. 文案加载提示
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:HUD_MESSAGE_FONT_SIZE];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 0;
        textLabel.tag = 99;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.preferredMaxLayoutWidth = HUD_MAX_WIDTH - HUD_MARGIN;
        textLabel.text = message;
        [customView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(customView.mas_leading).with.offset(HUD_MARGIN);
            make.centerY.mas_equalTo(customView.mas_centerY);
        }];
        
        CGSize labelSize = [textLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        // 2. 取消按钮
        HUDCancelButton *cancelButton = [[HUDCancelButton alloc] init];
        cancelButton.cancelCallback = cancelCallback;
        [cancelButton setImage:[UIImage imageNamed:@"hud_ic_cancel"] forState:UIControlStateNormal];
        [cancelButton setBackgroundColor:HUD_CANCEL_BACKGROUND_COLOR];
        [cancelButton addTarget:[HUD class]
                         action:@selector(cancelButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(customView.mas_trailing);
            make.leading.mas_equalTo(textLabel.mas_trailing);
            make.centerY.equalTo(customView);
            make.size.mas_equalTo(HUD_CANCEL_BUTTON_SIZE);
        }];
        
        CGSize buttonSize = [cancelButton systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        size = CGSizeMake(labelSize.width+buttonSize.width+2*HUD_MARGIN, MAX(labelSize.height+2*HUD_MARGIN, buttonSize.height));
    }
    
    size.width = MAX(size.width, HUD_MIN_SIZE.width);
    size.height = MAX(size.height, HUD_MIN_SIZE.height);
    
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.customView = customView;
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    
    [hud showAnimated:YES];
    return hud;
}

// 错误图标 错误文案
+ (void)showErrorWithMessage:(NSString *)message
{
    UIWindow *topWindow = [HUD topWindow];
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:topWindow];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:topWindow animated:YES];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:hud];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    
    [HUD resetHUD:hud];
    
    UIView *customView = [[UIView alloc] init];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    // 1. 错误图标
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_ic_error"]];
    [customView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customView.mas_centerX);
        make.top.equalTo(customView.mas_top).with.offset(0);
    }];
    
    CGSize imageViewSize = [imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // 2. 错误提示
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:HUD_MESSAGE_FONT_SIZE];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.preferredMaxLayoutWidth = HUD_MAX_WIDTH;
    textLabel.text = message;
    [customView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(HUD_PADDING);
    }];
    
    CGSize labelSize = [textLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGSize size = CGSizeMake(MAX(imageViewSize.width, labelSize.width), imageViewSize.height+HUD_PADDING+labelSize.height);
    size.width = MAX(size.width, HUD_MIN_SIZE.width);
    size.height = MAX(size.height, HUD_MIN_SIZE.height);
    
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.customView = customView;
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:HUD_DEFAULT_DURATION];
}

+ (void)hideAnimated:(BOOL)animated
{
    UIWindow *topWindow = [HUD topWindow];
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:topWindow];
    if (hud != nil) {
        [hud hideAnimated:animated];
    }
}

+ (void)resetHUD:(MBProgressHUD *)hud
{
    hud.customView = nil;
    
    hud.minSize = HUD_MIN_SIZE;
    hud.margin = HUD_MARGIN;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    hud.bezelView.color = [UIColor blackColor];
    
    hud.removeFromSuperViewOnHide = YES;
    
    hud.label.text = @"";
    hud.label.font = [UIFont systemFontOfSize:HUD_MESSAGE_FONT_SIZE];
    hud.label.textColor = [UIColor whiteColor];
    
    hud.detailsLabel.text = @"";
    hud.detailsLabel.font = [UIFont systemFontOfSize:HUD_MESSAGE_FONT_SIZE];
    hud.detailsLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Helpers

+ (UIWindow *)topWindow
{
    UIWindow *window = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        window = [[UIApplication sharedApplication].delegate performSelector:@selector(window)];
    }

    if (window != nil) {
        return window;
    }

    return [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        if (win1.frame.size.height != [[UIScreen mainScreen] bounds].size.height) {
            return NSOrderedAscending;
        }
        else if (win2.frame.size.height != [[UIScreen mainScreen] bounds].size.height) {
            return NSOrderedDescending;
        }
        
        if ([[win2.class description] isEqualToString:@"CustomStatusBar"] ||
            [[win2.class description] rangeOfString:@"TextEffects"].location != NSNotFound ||
            [[win2.class description] rangeOfString:@"Keyboard"].location != NSNotFound ||
            win2.rootViewController == nil) {
            return NSOrderedDescending;
        }
        else if ([[win1.class description] isEqualToString:@"CustomStatusBar"] ||
                 [[win1.class description] rangeOfString:@"TextEffects"].location != NSNotFound ||
                 [[win1.class description] rangeOfString:@"Keyboard"].location != NSNotFound ||
                 win1.rootViewController == nil) {
            return NSOrderedAscending;
        }
        
        return win1.windowLevel - win2.windowLevel;
    }] lastObject];
}

#pragma mark - Handle Actions

+ (void)cancelButtonClicked:(HUDCancelButton *)cancelButton {
    [HUD hideAnimated:YES];
    
    if (cancelButton.cancelCallback != nil) {
        cancelButton.cancelCallback();
    }
}

@end

