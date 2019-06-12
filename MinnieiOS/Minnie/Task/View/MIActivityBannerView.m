//
//  MIActivityBannerView.m
//  Minnie
//
//  Created by songzhen on 2019/6/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "UIView+YYAdd.h"
#import "MIActivityBannerView.h"

@interface MIActivityBannerView () <
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * mainView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
// 分页控件小圆标大小
@property (nonatomic, assign) CGSize pageControlDotSize;

@end

@implementation MIActivityBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _showPageControl = YES;
        _autoScroll = YES;
        _infiniteLoop = YES;
        _pageControlDotSize = CGSizeMake(8, 8);
        [self setupMainView];
        [self setupPageControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _flowLayout.itemSize = self.bounds.size;
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        } else {
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                          atScrollPosition:UICollectionViewScrollPositionNone
                                  animated:NO];
    }
    
    CGSize size = CGSizeMake(self.imagesGroup.count * self.pageControlDotSize.width * 1.2, self.pageControlDotSize.height);
    CGFloat x = (self.width - size.width) * 0.5;
    CGFloat y = self.mainView.height - size.height - 10;
    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
    _pageControl.hidden = !_showPageControl;
}

#pragma mark - setup
- (void)setupMainView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height - 40);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView * mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.scrollsToTop = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.dataSource = self;
    mainView.delegate = self;
    [mainView registerClass:[MIActivityBannerViewCell class] forCellWithReuseIdentifier:@"MIActivityBannerViewCell"];
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imagesGroup.count;
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)setupTimer
{
    if (self.imagesGroup.count <= 1) {
        return;
    }
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - setter
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    [_timer invalidate];
    _timer = nil;
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setImagesGroup:(NSMutableArray *)imagesGroup
{
    _imagesGroup = imagesGroup;
    _totalItemsCount = self.infiniteLoop ? self.imagesGroup.count * 100 : self.imagesGroup.count;
    
    if (imagesGroup.count != 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        _showPageControl = NO;
        self.mainView.scrollEnabled = NO;
    }
    [self setupPageControl];
    [self.mainView reloadData];
}

#pragma mark - selector
- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                          atScrollPosition:UICollectionViewScrollPositionNone
                                  animated:NO];
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                      atScrollPosition:UICollectionViewScrollPositionNone
                              animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MIActivityBannerViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MIActivityBannerViewCell" forIndexPath:indexPath];
    NSInteger itemIndex = indexPath.item % self.imagesGroup.count;
    ActivityInfo *actInfo = self.imagesGroup[itemIndex];
    NSString * url = actInfo.actCoverUrl;
    if (![url containsString:@"http"]) {
        cell.imageView.image = [UIImage imageNamed:url];
    } else {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:indexPath.item % self.imagesGroup.count];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.width * 0.5) / self.mainView.width;
    if (!self.imagesGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int indexOnPageControl = itemIndex % self.imagesGroup.count;
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

@end

@implementation MIActivityBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.width - 30, self.height)];
        _cellBgView.backgroundColor = [UIColor bgColor];
        _cellBgView.layer.cornerRadius = 12.0;
        _cellBgView.layer.masksToBounds = NO;
        [self.contentView addSubview:_cellBgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:_cellBgView.bounds];
        _imageView.backgroundColor = [UIColor bgColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.contentScaleFactor = [UIScreen mainScreen].scale;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 12.0;
        _imageView.layer.masksToBounds = YES;
        [_cellBgView addSubview:_imageView];
    }
    return self;
}

@end
