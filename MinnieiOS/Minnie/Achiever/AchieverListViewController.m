//
//  AchieverListViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/5.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AchieverListViewController.h"
#import "AchieverListCollectionViewCell.h"
#import "AchieverListHeaderView.h"
#import "AchieverService.h"
#import "UIView+Load.h"
#import "AlertView.h"
@interface AchieverListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic, strong)NSMutableArray * achieverLists;
@property (nonatomic, strong) BaseRequest * achieverRequest;
@end

@implementation AchieverListViewController

- (void)dealloc {
    
    [self.achieverRequest clearCompletionBlock];
    [self.achieverRequest stop];
    self.achieverRequest = nil;
    
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _achieverLists = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(80, 120);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  //  layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = (ScreenWidth - 240 - 60) / 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
    layout.headerReferenceSize =  CGSizeMake(ScreenWidth, 40);
    self.mCollectionView.collectionViewLayout = layout;
    
    [self registerCellNib];
    
    [self requestAchievrList];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private
- (IBAction)backPress:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)requestAchievrList
{
    if (self.achieverRequest != nil) {
        return;
    }
    
    if (self.achieverLists.count == 0) {
        [self.view showLoadingView];
        self.mCollectionView.hidden = YES;
    }
    WeakifySelf;
    self.achieverRequest = [AchieverService requestMedalDetailWithCallback:^(Result *result, NSError *error) {
        StrongifySelf;
        [strongSelf handleRequestResult:result error:error];
    }];
}

- (void)handleRequestResult:(Result *)result error:(NSError *)error
{
    
    [self.achieverRequest clearCompletionBlock];
    self.achieverRequest = nil;
    
    [self.view hideAllStateView];
    
    WeakifySelf;
    if (error != nil) {
        [self.view showFailureViewWithRetryCallback:^{
            [weakSelf requestAchievrList];
        }];
        return;
    }
    
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSArray * achievers = dictionary[@"list"];
    self.mCollectionView.hidden = NO;
    [self.achieverLists removeAllObjects];
    [self.achieverLists addObjectsFromArray:achievers];
    [self.mCollectionView reloadData];
}

- (void)registerCellNib
{
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"AchieverListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:AchieverListCollectionViewCellId];
    
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"AchieverListHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AchieverListCollectionHeaderViewId];
    
}

- (void)showAlertMedalInfo:(id)data
{
    [AlertView showInView:self.view
                withImage:[UIImage imageNamed:@"pop_img_welcome"]
                    title:@"欢迎加入minnie英文教室"
                  message:@"你目前已报名, 请等待教师回复"
                   action:@"知道啦"
           actionCallback:^{
           }];
}

#pragma mark - CollectionDelegete && Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AchieverListCollectionViewCell * cell = (AchieverListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AchieverListCollectionViewCellId forIndexPath:indexPath];
    [cell setContentData:nil];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AchieverListHeaderView * headerView = (AchieverListHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AchieverListCollectionHeaderViewId forIndexPath:indexPath];
    headerView.nameLabel.text = @"人人夸";
    return headerView;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
