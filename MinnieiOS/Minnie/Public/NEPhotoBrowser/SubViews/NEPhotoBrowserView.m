//
//  NEPhotoBrowserView.m
//  NECatoonReader
//
//  Created by hubo on 15/9/13.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import "NEPhotoBrowserView.h"
#import "NEPhotoIndicatorView.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImageView+WebCache.h"
#import "FLAnimatedImageView.h"

static CGFloat const kMinZoomScale = 0.6;
static CGFloat const kMaxZoomScale = 2.0;
static NSInteger const kTagOfPhotoIndicatorView = 1002;

@interface NEPhotoBrowserView() <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NEPhotoIndicatorView *indicatorView;
@property (strong, nonatomic) UIButton *reloadButton;
@property (strong, nonatomic) UIImage *placeHolderImage;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) NSURL *imageUrl;

@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) BOOL isBeginLoadingImage;
@property (assign, nonatomic) BOOL isHadLoadedImage;
@end

@implementation NEPhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollview];
        [self addGestureRecognizer:self.doubleTapGestureRecognizer];
        [self addGestureRecognizer:self.singleTapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _indicatorView.center = _scrollView.center;
    _scrollView.frame = self.bounds;
    _reloadButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, [UIScreen mainScreen].bounds.size.height * 0.5f);
    [self updateFrames];
}

- (void)updateFrames {
    CGRect frame = self.scrollview.frame;
    if (self.imageView.image) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat ratio = self.imageView.image.size.width / self.imageView.image.size.height;
        CGFloat imageWidth = self.imageView.image.size.width;
        CGFloat imageHeight = self.imageView.image.size.height;
        
        // 进入全屏看大图，实际图片宽度<＝100时，按照＊3后显示，其它尺寸按宽度全屏显示
        CGRect imageFrame = CGRectZero;
        if (imageWidth <= 100 && !self.isScaleToScreenWidth) {
            // 小图显示
            imageWidth = (imageWidth * 3) / scale;
            imageHeight = (imageHeight * 3) / scale;
        } else {
            // 大图撑到屏幕宽度
            imageWidth = [UIScreen mainScreen].bounds.size.width;
            imageHeight = imageWidth/ratio;
        }
        
        imageFrame.size.width = imageWidth;
        imageFrame.size.height = imageHeight;
        self.imageView.frame = imageFrame;
        self.scrollview.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollViewContent:self.scrollview];
        
        CGFloat maxScale = frame.size.height / imageFrame.size.height;
        maxScale = frame.size.width / imageFrame.size.width>maxScale ? frame.size.width / imageFrame.size.width:maxScale;
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.zoomScale = 1.0f;
    } else {
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        self.scrollview.contentSize = self.imageView.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark - Load Imgage

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    if (_isBeginLoadingImage) {
        return;
    }
    _isBeginLoadingImage = YES;
    
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeholder;
    _isHadLoadedImage = NO;
    
    // 进度指示器
    NEPhotoIndicatorView *indicatorView = [self viewWithTag:kTagOfPhotoIndicatorView];
    if(self.hideLoadingView) {
        indicatorView.hidden = YES;
    } else {
        if (indicatorView == nil) {
            indicatorView = [[NEPhotoIndicatorView alloc] init];
            indicatorView.tag = kTagOfPhotoIndicatorView;
            indicatorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, [UIScreen mainScreen].bounds.size.height * 0.5f);
            self.indicatorView = indicatorView;
            [self addSubview:indicatorView];
        }
        indicatorView.hidden = NO;
    }
    self.indicatorView.progress = 0.f;
    
    // 加载图片
    _imageView.image = placeholder;
    [self setNeedsLayout];
    
    __weak __typeof__(self) weakSelf = self;
    [_imageView sd_setImageWithURL:url
                  placeholderImage:placeholder
                           options:SDWebImageRetryFailed
                          progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  __strong __typeof__(weakSelf) strongSelf = weakSelf;
                                  if (!strongSelf.hideLoadingView) {
                                      strongSelf.indicatorView.progress = (CGFloat)receivedSize / expectedSize;
                                  }
                              });
                          }
                         completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                             __strong __typeof__(weakSelf) strongSelf = weakSelf;
                             strongSelf.isBeginLoadingImage = NO;
                             [strongSelf.indicatorView setHidden:YES];
                             [strongSelf setNeedsLayout];
                             
                             if (error != nil) {
                                 strongSelf.isHadLoadedImage = NO;
                                 
                                 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                 strongSelf.reloadButton = button;
                                 button.layer.cornerRadius = 2;
                                 button.clipsToBounds = YES;
                                 button.bounds = CGRectMake(0.f, 0.f, 200.f, 40.f);
                                 button.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, [UIScreen mainScreen].bounds.size.height * 0.5f);
                                 button.titleLabel.font = [UIFont systemFontOfSize:14];
                                 button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
                                 [button setTitle:@"原图加载失败，点击重新加载" forState:UIControlStateNormal];
                                 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                 [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
                                 
                                 [strongSelf addSubview:button];
                                 return;
                             } else {
                                 strongSelf.isHadLoadedImage = YES;
                             }
                         }];
}

- (void)reloadImage {
    [self loadImageWithURL:_imageUrl placeholderImage:_placeHolderImage];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _indicatorView.progress = progress;
}

#pragma mark - Action

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    // 图片加载完之后才能响应双击放大
    if (!self.isHadLoadedImage) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x; // 需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y; // 需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark - Reset Image

- (void)resetImageView {
    self.scrollView.zoomScale = 1.0;
}

#pragma mark - Property

- (UIScrollView *)scrollview {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0.f, 0.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_scrollView addSubview:self.imageView];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[FLAnimatedImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer {
    if (_doubleTapGestureRecognizer == nil) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        _doubleTapGestureRecognizer.numberOfTouchesRequired  =1;
    }
    return _doubleTapGestureRecognizer;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer {
    if (_singleTapGestureRecognizer == nil) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTapGestureRecognizer.numberOfTapsRequired = 1;
        _singleTapGestureRecognizer.numberOfTouchesRequired = 1;
        [_singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    }
    return _singleTapGestureRecognizer;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

@end

