//
//  TIP.m
//
//  Created by yebw on 14/12/22.
//

#import "TIP.h"

#define kMaxWidthOfTIP         240.f
#define kMinWidthOfTIP         120.f
#define kMinHeightOfTIP        28.f
#define kBottomSpaceOfTIP      70.f
#define kVerticalSpaceOfTIP    6.f
#define kHorizontalSpaceOfTIP  16.f


@interface TIP ()

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView; // 背景图
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;

+ (instancetype)sharedInstance;

@end

@implementation TIP

+ (instancetype)sharedInstance
{
    static TIP *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[NSBundle mainBundle] loadNibNamed:@"TIP" owner:nil options:nil] lastObject];
        [instance setBackgroundColor:[UIColor clearColor]];
    });
    
    return instance;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if (v == self) {
        return nil;
    }

    return v;
}

+ (void)showText:(NSString *)text inView:(UIView *)view withTopOffset:(CGFloat)offset andDuration:(CGFloat)duration
{
    TIP *tipView = [TIP sharedInstance];
    if (tipView.superview != nil) {
        [NSObject cancelPreviousPerformRequestsWithTarget:tipView selector:@selector(hideWithAnimation) object:nil];
        [tipView removeFromSuperview];
    }
    
    [view addSubview:tipView];
    
    [tipView setFrame:view.bounds];
    [tipView.tipLabel setText:text];
    [tipView.bgImageView setImage:nil];
    
    // 计算合适大小
    CGRect frame = [text boundingRectWithSize:CGSizeMake(kMaxWidthOfTIP-2*kHorizontalSpaceOfTIP, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:tipView.tipLabel.font}
                                      context:nil];
    CGSize size = CGSizeMake(frame.size.width+4.f, frame.size.height+2);
    
    CGFloat width = MIN(MAX(size.width+2*kHorizontalSpaceOfTIP, kMinWidthOfTIP), kMaxWidthOfTIP);
    CGFloat height = MAX(kMinHeightOfTIP, size.height+2*kVerticalSpaceOfTIP);
    [tipView.contentView setFrame:CGRectMake((view.bounds.size.width-width)/2, offset, width, height)];
    
    tipView.contentView.layer.cornerRadius = height/2;
    tipView.contentView.layer.masksToBounds = YES;
    tipView.contentView.clipsToBounds = NO;
    tipView.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.contentView.layer.shadowOffset = CGSizeMake(2, 2);
    tipView.contentView.layer.shadowOpacity = 0.3;
    
    tipView.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3f
                          delay:0.f
         usingSpringWithDamping:0.5
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         tipView.contentView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                     }];
    
    [tipView performSelector:@selector(hideWithAnimation)
                  withObject:nil
                  afterDelay:duration
                     inModes:@[NSRunLoopCommonModes]];
}

+ (void)showText:(NSString *)text inView:(UIView *)view withTopOffset:(CGFloat)offset
{
    [TIP showText:text inView:view withTopOffset:offset andDuration:1.5f];
}


+ (void)showText:(NSString *)text
          inView:(UIView *)view
withBottomOffset:(CGFloat)offset
     andDuration:(CGFloat)duration
{
    TIP *tipView = [TIP sharedInstance];
    if (tipView.superview != nil) {
        [NSObject cancelPreviousPerformRequestsWithTarget:tipView selector:@selector(hideWithAnimation) object:nil];
        [tipView removeFromSuperview];
    }

    [view addSubview:tipView];
    
    [tipView setFrame:view.bounds];
    [tipView.tipLabel setText:text];
    [tipView.bgImageView setImage:nil];

    // 计算合适大小
    CGRect frame = [text boundingRectWithSize:CGSizeMake(kMaxWidthOfTIP-2*kHorizontalSpaceOfTIP, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName:tipView.tipLabel.font}
                                      context:nil];
    CGSize size = CGSizeMake(frame.size.width+4.f, frame.size.height+2);
    
    CGFloat width = MIN(MAX(size.width+2*kHorizontalSpaceOfTIP, kMinWidthOfTIP), kMaxWidthOfTIP);
    CGFloat height = MAX(kMinHeightOfTIP, size.height+2*kVerticalSpaceOfTIP);
    [tipView.contentView setFrame:CGRectMake((view.bounds.size.width-width)/2, view.bounds.size.height-offset-height, width, height)];
    
    tipView.contentView.layer.cornerRadius = height/2;
    tipView.contentView.layer.masksToBounds = YES;
    tipView.contentView.clipsToBounds = NO;
    tipView.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.contentView.layer.shadowOffset = CGSizeMake(2, 2);
    tipView.contentView.layer.shadowOpacity = 0.3;

    tipView.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3f
                          delay:0.f
         usingSpringWithDamping:0.5
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         tipView.contentView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                     }];

    [tipView performSelector:@selector(hideWithAnimation)
                  withObject:nil
                  afterDelay:duration
                     inModes:@[NSRunLoopCommonModes]];
}

+ (void)showText:(NSString *)text inView:(UIView *)view withBottomOffset:(CGFloat)offset
{
    [TIP showText:text inView:view withBottomOffset:offset andDuration:1.5];
}

+ (void)showText:(NSString *)text inView:(UIView *)view withDuration:(CGFloat)duration
{
    [TIP showText:text inView:view withBottomOffset:kBottomSpaceOfTIP andDuration:duration];
}

+ (void)showText:(NSString *)text inView:(UIView *)view
{
    [TIP showText:text inView:view withBottomOffset:kBottomSpaceOfTIP andDuration:1.5f];
}

+ (void)showImage:(UIImage *)image inView:(UIView *)view withDuration:(CGFloat)duration withOffset:(CGFloat)offset
{
    TIP *tipView = [TIP sharedInstance];
    if (tipView.superview != nil) {
        [NSObject cancelPreviousPerformRequestsWithTarget:tipView selector:@selector(hideWithAnimation) object:nil];
        [tipView removeFromSuperview];
    }
    
    [view addSubview:tipView];
    [tipView setFrame:view.bounds];
    [tipView.bgImageView setImage:image];
    [tipView.tipLabel setText:nil];
    [tipView.contentView setBackgroundColor:[UIColor clearColor]];

    CGSize size = image.size;
    [tipView.contentView setFrame:CGRectMake((view.bounds.size.width-size.width)/2, view.bounds.size.height-offset-size.height, size.width, size.height)];
    
    tipView.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3f
                          delay:0.f
         usingSpringWithDamping:0.5
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         tipView.contentView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                     }];
    
    [tipView performSelector:@selector(hideWithAnimation) withObject:nil afterDelay:duration inModes:@[NSRunLoopCommonModes]];
}

+ (void)showProgressWithText:(NSString *)text inView:(UIView *)view
{
    TIP *tipView = [TIP sharedInstance];
    if (tipView.superview != nil) {
        [NSObject cancelPreviousPerformRequestsWithTarget:tipView selector:@selector(hideWithAnimation) object:nil];
        [tipView removeFromSuperview];
    }
    
    [view addSubview:tipView];

    [tipView setFrame:view.bounds];
    [tipView.tipLabel setText:text];
    [tipView.bgImageView setImage:nil];

    CGRect frame = [text boundingRectWithSize:CGSizeMake(kMaxWidthOfTIP-2*kHorizontalSpaceOfTIP, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:tipView.tipLabel.font}
                                      context:nil];
    CGSize size = CGSizeMake(frame.size.width+4.f, frame.size.height+2);
    
    CGFloat width = MIN(MAX(size.width+2*kHorizontalSpaceOfTIP, kMinWidthOfTIP), kMaxWidthOfTIP);
    CGFloat height = MAX(kMinHeightOfTIP, size.height+2*kVerticalSpaceOfTIP);
    [tipView.contentView setFrame:CGRectMake((view.bounds.size.width-width)/2, view.bounds.size.height-kBottomSpaceOfTIP-height, width, height)];
    
    tipView.contentView.layer.cornerRadius = height/2;
    tipView.contentView.layer.masksToBounds = YES;
    tipView.contentView.clipsToBounds = NO;
    tipView.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.contentView.layer.shadowOffset = CGSizeMake(2, 2);
    tipView.contentView.layer.shadowOpacity = 0.3;
    
    [tipView setAlpha:0.f];
    [UIView animateWithDuration:0.05f animations:^{
        [tipView setAlpha:1.f];
    } completion:^(BOOL finished) {
        [tipView removeFromSuperview];
    }];
}

+ (void)hideAnimated:(BOOL)animated
{
    TIP *tipView = [TIP sharedInstance];
    if (tipView.superview == nil) {
        return;
    }
    
    if (animated) {
        [tipView hideWithAnimation];
    } else {
        [tipView setAlpha:1.f];
        [tipView removeFromSuperview];
    }
}

- (void)hideWithAnimation
{
    [UIView animateWithDuration:0.15f animations:^{
        [self setAlpha:0.f];
    } completion:^(BOOL finished) {
        [self setAlpha:1.f];
        [self removeFromSuperview];
    }];
}

@end
