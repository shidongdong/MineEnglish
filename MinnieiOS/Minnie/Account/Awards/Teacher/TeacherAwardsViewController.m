//
//  AwardsViewController.m
//  X5
//
//  Created by yebw on 2017/8/28.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "TeacherAwardsViewController.h"
#import "CreateAwardViewController.h"
#import "TeacherAwardCollectionViewCell.h"
#import "Award.h"
#import "ExchangeAwardView.h"
#import "TeacherAwardService.h"
#import "UIView+Load.h"
#import "UIScrollView+Refresh.h"
#import "ProgressHUD.h"

@interface TeacherAwardsViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIView *awardsCollectionContainerView;
@property (nonatomic, weak) IBOutlet UICollectionView *awardsCollectionView;
@property (nonatomic, weak) IBOutlet UIButton *createButton;

@property (nonatomic, strong) NSMutableArray<Award *> *awards;
@property (nonatomic, strong) BaseRequest *awardsRequest;

@property (nonatomic, assign) BOOL shouldReloadWhenAppeared;

@end

@implementation TeacherAwardsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.createButton.hidden = !APP.currentUser.canCreateRewards;
    
    [self registerCellNibs];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldReloadWhenAppeared:)
                                                 name:kNotificationKeyOfAddAward
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shouldReloadWhenAppeared) {
        self.shouldReloadWhenAppeared = NO;
        
        [self requestData];
    }
#if MANAGERSIDE
    [self.navigationController setNavigationBarHidden:YES animated:NO];
#endif
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.awardsRequest clearCompletionBlock];
    [self.awardsRequest stop];
    self.awardsRequest = nil;
    
    NSLog(@"%s", __func__);
}

- (IBAction)createButtonPressed:(id)sender {
    CreateAwardViewController *vc = [[CreateAwardViewController alloc] initWithNibName:NSStringFromClass([CreateAwardViewController class]) bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods

- (void)shouldReloadWhenAppeared:(NSNotification *)notification {
    self.shouldReloadWhenAppeared = YES;
}

- (void)registerCellNibs {
    [self.awardsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherAwardCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TeacherAwardCollectionViewCellId];
}

- (void)requestData {
    if (self.awardsRequest != nil) {
        return;
    }
    
    self.awards = nil;

    self.awardsCollectionView.hidden = YES;
    [self.awardsCollectionContainerView showLoadingView];
    
    WeakifySelf;
    self.awardsRequest = [TeacherAwardService requestAwardsWithCallback:^(Result *result, NSError *error) {
        StrongifySelf;
        
        strongSelf.awardsRequest = nil;
        
        // 显示失败页面
        if (error != nil) {
            [strongSelf.awardsCollectionContainerView showFailureViewWithRetryCallback:^{
                [weakSelf requestData];
            }];
            
            return;
        }
        
        NSArray *awards = (NSArray <Award *>*)(((NSDictionary *)(result.userInfo))[@"list"]);
        if (awards.count == 0) {
            [strongSelf.awardsCollectionContainerView showEmptyViewWithImage:nil
                                                                       title:@"没有可兑换的礼物"
                                                                   linkTitle:nil
                                                           linkClickCallback:nil];
        } else {
            if (strongSelf.awards == nil) {
                strongSelf.awards = [NSMutableArray array];
            } else {
                [strongSelf.awards removeAllObjects];
            }
            [strongSelf.awards addObjectsFromArray:awards];
            
            [strongSelf.awardsCollectionContainerView hideAllStateView];
            strongSelf.awardsCollectionView.hidden = NO;
            [strongSelf.awardsCollectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.awards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeacherAwardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeacherAwardCollectionViewCellId
                                                                              forIndexPath:indexPath];
    Award *award = self.awards[indexPath.row];
    
    [cell setupWithAward:award];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [TeacherAwardCollectionViewCell size];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 12, 16, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    Award *award = self.awards[indexPath.row];
    
    CreateAwardViewController *vc = [[CreateAwardViewController alloc] initWithNibName:NSStringFromClass([CreateAwardViewController class]) bundle:nil];
    vc.award = award;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

