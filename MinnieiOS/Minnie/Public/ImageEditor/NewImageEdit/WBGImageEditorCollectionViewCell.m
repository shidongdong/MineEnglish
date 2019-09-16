//
//  WBGImageEditorCollectionViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/1/5.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "WBGImageEditorCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+YYAdd.h"
#import "YYCategories.h"

NSString * const WBGImageEditorCollectionViewCellId = @"WBGImageEditorCollectionViewCellId";

@interface WBGImageEditorCollectionViewCell()<UIScrollViewDelegate>

@property (weak,   nonatomic) IBOutlet UIImageView *imageView;
@property (weak,   nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy  ) UIImage   *originImage;

@end

@implementation WBGImageEditorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustInit];
    // Initialization code
}


#pragma mark - private
- (void)adjustInit
{
    [self initImageScrollView];
    
    [self refreshImageView];
}


- (void)initImageScrollView {
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    
}

- (void)setupThumbImage:(UIImage *)thumbnailImage withOrignImageURLURL:(NSString *)originalImageUrl
{
    if (originalImageUrl.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:originalImageUrl]
                          placeholderImage:thumbnailImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                              if (error == nil) {
                                  [self performSelector:@selector(adjustInit) withObject:nil afterDelay:0.5];
                                  // [self adjustCanvasSize];
                              }
                          }];
    } else {
        self.imageView.image = thumbnailImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self adjustInit];
            // [self adjustCanvasSize];
        });
    }
}


- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 ) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
}

- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.originImage;
    }
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];

}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = 0;
    if (_imageView.frame.size.width > 0) {
        Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    }
    CGFloat Rh = 0;
    if (_imageView.frame.size.height) {
        Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    }
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 3);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{ }

@end
