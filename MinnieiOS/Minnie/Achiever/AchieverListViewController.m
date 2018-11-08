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
@interface AchieverListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

@end

@implementation AchieverListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(80, 120);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  //  layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = (ScreenWidth - 240 - 60) / 2;
    layout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30);
    layout.headerReferenceSize =  CGSizeMake(ScreenWidth, 40);
    self.mCollectionView.collectionViewLayout = layout;
    
    [self registerCellNib];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backPress:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)registerCellNib
{
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"AchieverListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:AchieverListCollectionViewCellId];
    
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"AchieverListHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AchieverListCollectionHeaderViewId];
    
}

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
