//
//  ClassAndStudentSelectorController.m
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "StudentsViewController.h"
#import "StudentSelectorViewController.h"
#import "SegmentControl.h"
#import "Constants.h"
#import "StudentDetailViewController.h"
#import <Masonry/Masonry.h>
#import "PushManager.h"

@interface StudentsViewController ()

@property (nonatomic, strong) StudentSelectorViewController *studentsSelectorChildController;
@property (nonatomic, strong) StudentSelectorViewController *enrollingStudentsSelectorChildController;

@property (nonatomic, assign) BOOL ignoreScrollCallback;

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, weak) IBOutlet UIView *customTitleView;
@property (nonatomic, weak) SegmentControl *segmentControl;

@property (nonatomic, strong) NSArray *teachers;

@property (nonatomic, assign) NSInteger selectedClassesCount;
@property (nonatomic, assign) NSInteger selectedStudentsCount;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightLayoutConstraint;

@end

@implementation StudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isIPhoneX) {
        self.heightLayoutConstraint.constant = -(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
    }
    
    self.segmentControl = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SegmentControl class]) owner:nil options:nil] lastObject];
    self.segmentControl.titles = @[@"已入学", @"未入学"];
    self.segmentControl.selectedIndex = 0;

    __weak typeof(self) weakSelf = self;
    self.segmentControl.indexChangeHandler = ^(NSUInteger selectedIndex) {
        [weakSelf showChildPageViewControllerWithIndex:selectedIndex animated:YES shouldLocate:YES];
    };
    [self.customTitleView addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.customTitleView);
    }];
    
    [self showChildPageViewControllerWithIndex:0 animated:NO shouldLocate:YES];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - IBActions

- (IBAction)backButtonPressed:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showChildPageViewControllerWithIndex:(NSUInteger)index animated:(BOOL)animated shouldLocate:(BOOL)shouldLocate {
    BaseViewController *childPageViewController = nil;
    BOOL existed = YES;
    
    if (index == 0) {
        if (self.studentsSelectorChildController == nil) {
            self.studentsSelectorChildController = [[StudentSelectorViewController alloc] initWithNibName:NSStringFromClass([StudentSelectorViewController class]) bundle:nil];
            self.studentsSelectorChildController.reviewMode = YES;
            self.studentsSelectorChildController.classStateMode = YES;
            self.studentsSelectorChildController.inClass = YES;
            existed = NO;
            
            WeakifySelf;
            self.studentsSelectorChildController.selectCallback = ^(NSInteger count) {
                weakSelf.selectedClassesCount = count;
                
                [weakSelf.enrollingStudentsSelectorChildController unselectAll];
            };
            
            self.studentsSelectorChildController.previewCallback = ^(NSInteger userId) {
                StudentDetailViewController *vc = [[StudentDetailViewController alloc] initWithNibName:@"StudentDetailViewController" bundle:nil];
                vc.userId = userId;
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        
        childPageViewController = self.studentsSelectorChildController;
    } else if (index == 1) {
        if (self.enrollingStudentsSelectorChildController == nil) {
            self.enrollingStudentsSelectorChildController = [[StudentSelectorViewController alloc] initWithNibName:NSStringFromClass([StudentSelectorViewController class]) bundle:nil];
            self.enrollingStudentsSelectorChildController.reviewMode = YES;
            self.enrollingStudentsSelectorChildController.classStateMode = YES;
            self.enrollingStudentsSelectorChildController.inClass = NO;

            existed = NO;
            
            WeakifySelf;
            self.enrollingStudentsSelectorChildController.selectCallback = ^(NSInteger count) {
                weakSelf.selectedStudentsCount = count;
                
                [weakSelf.studentsSelectorChildController unselectAll];
            };
            
            self.enrollingStudentsSelectorChildController.previewCallback = ^(NSInteger userId) {
                StudentDetailViewController *vc = [[StudentDetailViewController alloc] initWithNibName:@"StudentDetailViewController" bundle:nil];
                vc.userId = userId;
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        
        childPageViewController = self.enrollingStudentsSelectorChildController;
    }
    
    if (!existed) {
        [self addChildViewController:childPageViewController];
        
        [self.containerView addSubview:childPageViewController.view];
        [self addContraintsWithX:index*ScreenWidth view:childPageViewController.view superView:self.containerView];
        
        [childPageViewController didMoveToParentViewController:self];
    }
    
    if (shouldLocate) {
        CGPoint offset = CGPointMake(index*ScreenWidth, 0);
        
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

- (void)addContraintsWithX:(CGFloat)offsetX view:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:offsetX];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:ScreenWidth];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:superView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    [superView addConstraints:@[leadingConstraint, widthConstraint, topConstraint, bottomConstraint]];
}

- (void)updateSegmentControlWithOffsetX:(CGFloat)x {
    [self.segmentControl setPersent:x / ScreenWidth];
}

- (void)updateSegmentControlWhenScrollEnded {
    [self.segmentControl setPersent:self.containerScrollView.contentOffset.x / ScreenWidth];
    
    NSInteger index = MAX(0, ceil(2 * self.containerScrollView.contentOffset.x / ScreenWidth) - 1);
    [self indexDidChange:index];
}

- (void)indexDidChange:(NSInteger)index {
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.ignoreScrollCallback) {
        return;
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger leftIndex = (NSInteger)MAX(0, offsetX)/(NSInteger)(ScreenWidth);
    NSUInteger rightIndex = (NSInteger)MAX(0, offsetX+ScreenWidth)/(NSInteger)(ScreenWidth);
    
    [self showChildPageViewControllerWithIndex:leftIndex animated:NO shouldLocate:NO];
    if (leftIndex != rightIndex) {
        [self showChildPageViewControllerWithIndex:rightIndex animated:NO shouldLocate:NO];
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

@end

