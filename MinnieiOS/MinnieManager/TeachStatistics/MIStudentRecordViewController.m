//
//  MIStudentRecordViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/11.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "SegmentControl.h"
#import "MIStudentRecordViewController.h"

@interface MIStudentRecordViewController ()<
UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) SegmentControl *segmentControl;

@property (nonatomic, assign) BOOL ignoreScrollCallback;

@property (nonatomic, strong) UIScrollView *containerScrollView;


@end

@implementation MIStudentRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor emptyBgColor];
    
    
    self.segmentControl = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SegmentControl class]) owner:nil options:nil] lastObject];
    self.segmentControl.titles = @[@"星星获取", @"礼物兑换",@"任务得分",@"考试统计"];
    self.segmentControl.selectedIndex = 0;
    __weak typeof(self) weakSelf = self;
    self.segmentControl.indexChangeHandler = ^(NSUInteger selectedIndex) {
        [weakSelf showChildPageViewWithIndex:selectedIndex animated:YES shouldLocate:YES];
    };
    [self.view addSubview:self.segmentControl];
 
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNaviBarHeight);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kColumnThreeWidth);
    }];
    
    _containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight + 30, kColumnThreeWidth, ScreenHeight - (kNaviBarHeight + 30))];
    _containerScrollView.pagingEnabled = YES;
    _containerScrollView.showsHorizontalScrollIndicator = NO;
    _containerScrollView.contentSize = CGSizeMake(kColumnThreeWidth * 4, 200);
    _containerScrollView.delegate = self;
    [self.view addSubview:_containerScrollView];
}

- (void)showChildPageViewWithIndex:(NSUInteger)index animated:(BOOL)animated shouldLocate:(BOOL)shouldLocate {
    
    if (shouldLocate) {
        
        CGPoint offset = CGPointMake(index*kColumnThreeWidth, 0);
        if (animated) {
            self.ignoreScrollCallback = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.containerScrollView setContentOffset:offset];
                             } completion:^(BOOL finished) {
                                 self.ignoreScrollCallback = NO;
                             }];
        } else {
            // 说明：不使用dispatch_async的话viewDidLoad中直接调用[self.containerScrollView setContentOffset:offset];
            // 会导致contentoffset并未设置的问题
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ignoreScrollCallback = YES;
                [self.containerScrollView setContentOffset:offset];
                self.ignoreScrollCallback = NO;
            });
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.ignoreScrollCallback) {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger leftIndex = (NSInteger)MAX(0, offsetX)/(NSInteger)(kColumnThreeWidth);
    NSUInteger rightIndex = (NSInteger)MAX(0, offsetX+kColumnThreeWidth)/(NSInteger)(kColumnThreeWidth);
    
    [self showChildPageViewWithIndex:leftIndex animated:NO shouldLocate:NO];
    if (leftIndex != rightIndex) {
        [self showChildPageViewWithIndex:rightIndex animated:NO shouldLocate:NO];
    }
    
    [self updateSegmentControlWithOffsetX:offsetX];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.ignoreScrollCallback) {
        return;
    }
    
    if (!decelerate) {
        [self updateSegmentControlWhenScrollEnded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.ignoreScrollCallback) {
        return;
    }
    
    [self updateSegmentControlWhenScrollEnded];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (self.ignoreScrollCallback) {
        return;
    }
    [self updateSegmentControlWhenScrollEnded];
}

- (void)updateSegmentControlWhenScrollEnded {
    [self.segmentControl setPersent:self.containerScrollView.contentOffset.x / kColumnThreeWidth];
}

- (void)updateSegmentControlWithOffsetX:(CGFloat)x {
    [self.segmentControl setPersent:x / kColumnThreeWidth];
}


@end
