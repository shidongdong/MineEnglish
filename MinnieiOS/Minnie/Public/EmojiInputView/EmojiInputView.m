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

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

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

- (NSArray *)defaultEmoticons {
    
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i=0x1F600; i<=0x1F64F; i++) {
        
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym)encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
        
    }
    return array;
}

- (void)customInit {
    
    self.backgroundColor = [UIColor redColor];
    
    _emojis = [self defaultEmoticons];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.1;
    
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
    self.pageControl.numberOfPages = self.emojis.count/32 + ((self.emojis.count%32==0)?0:1);
    self.pageControl.currentPage = 0;
    
    [self addSubview:self.pageControl];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [sendBtn setBackgroundColor:[UIColor colorWithHex:0X0098FE]];
    sendBtn.layer.cornerRadius = 10.0;
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
}

- (void)sendPressed:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(emojiDidSend)]) {
        [self.delegate emojiDidSend];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emojis.count/32 + ((self.emojis.count%32==0)?0:1);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojiInputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmojiInputCollectionViewCellId forIndexPath:indexPath];
    
    NSInteger page = indexPath.item;
    NSRange range = NSMakeRange(page*32, MIN(32, self.emojis.count-page*32));
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

