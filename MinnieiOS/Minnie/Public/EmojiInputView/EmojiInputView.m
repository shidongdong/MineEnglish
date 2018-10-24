//
//  EmojiInputView.m
//  X5
//
//  Created by yebw on 2017/12/10.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "EmojiInputView.h"
#import "EmojiInputCollectionViewCell.h"
#import <Masonry/Masonry.h>

CGFloat const EmojiInputViewHeight = 216.f;

@interface EmojiInputView()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *emojis;
@property (nonatomic, strong) UICollectionView *emojisCollectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation EmojiInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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

- (void)customInit {
    _emojis = @[@"熬夜", @"报警", @"不错", @"点赞", @"乖巧", @"呵呵", @"懵逼", @"送花", @"同意", @"吐血", @"喜欢", @"吓到", @"笑哭", @"心累"];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.emojisCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.emojisCollectionView.backgroundColor = [UIColor whiteColor];
    self.emojisCollectionView.delegate = self;
    self.emojisCollectionView.dataSource = self;
    self.emojisCollectionView.scrollsToTop = NO;
    self.emojisCollectionView.pagingEnabled = YES;
    self.emojisCollectionView.alwaysBounceVertical = NO;
    self.emojisCollectionView.alwaysBounceHorizontal = NO;
    self.emojisCollectionView.showsVerticalScrollIndicator = NO;
    self.emojisCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.emojisCollectionView];
    [self.emojisCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.emojisCollectionView registerNib:[UINib nibWithNibName:@"EmojiInputCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:EmojiInputCollectionViewCellId];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.emojis.count/8 + ((self.emojis.count%8==0)?0:1);
    self.pageControl.currentPage = 0;
    
    [self addSubview:self.pageControl];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-5);
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emojis.count/8 + ((self.emojis.count%8==0)?0:1);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojiInputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmojiInputCollectionViewCellId forIndexPath:indexPath];
    
    NSInteger page = indexPath.item;
    NSRange range = NSMakeRange(page*8, MIN(8, self.emojis.count-page*8));
    NSArray *emojis = [self.emojis subarrayWithRange:range];
    
    __weak typeof(self) weakSelf = self;
    [cell setupWithEmojis:emojis
                 callback:^(NSString *text) {
                     if ([weakSelf.delegate respondsToSelector:@selector(emojiDidSelect:)]) {
                         [weakSelf.delegate emojiDidSelect:text];
                     }
                 }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 216.f);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width);
    self.pageControl.currentPage = index;
}

@end

