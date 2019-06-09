//
//  MIActivityRankListViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "UIView+Load.h"
#import "ManagerServce.h"
#import "MICreateTaskViewController.h"
#import "MIActivityRankListTableViewCell.h"
#import "MIActivityRankListViewController.h"
#import "MIParticipateDetailViewController.h"

@interface MIActivityRankListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) ActivityInfo *curActInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSMutableArray *okRankArray;
@property (strong, nonatomic) NSMutableArray *checkRankArray;

@property (assign, nonatomic) NSInteger currentActivityIndex;

@end

@implementation MIActivityRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
}

- (void)configureUI{
    self.view.backgroundColor = [UIColor bgColor];
    self.okRankArray = [NSMutableArray array];
    self.checkRankArray = [NSMutableArray array];
  
    UIView *footrView = [[UIView alloc] init];
    footrView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footrView;
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

#pragma mark -
- (void)requestGetActivityRankList{
    WeakifySelf;
    self.tableView.hidden = YES;
    [self.view showLoadingView];
    [ManagerServce requestGetActivityRankListWithActId:self.curActInfo.activityId callback:^(Result *result, NSError *error) {
        
        [weakSelf.view hideAllStateView];
        if (error) {
            WeakifySelf;
            
            weakSelf.tableView.hidden = YES;
            weakSelf.headerView.hidden = YES;
            [weakSelf.view showFailureViewWithRetryCallback:^{
                [weakSelf requestGetActivityRankList];
            }];
            return ;
        }
        
        ActivityRankListInfo * rankListInfo= (ActivityRankListInfo *)(result.userInfo);
        [weakSelf.okRankArray removeAllObjects];
        [weakSelf.okRankArray addObjectsFromArray:rankListInfo.okRank];
        [weakSelf.checkRankArray removeAllObjects];
        [weakSelf.checkRankArray addObjectsFromArray:rankListInfo.checkRank];
        
        if (weakSelf.okRankArray.count + weakSelf.checkRankArray.count == 0) {// 无数据
            
            weakSelf.tableView.hidden = YES;
            weakSelf.headerView.hidden = NO;
            [weakSelf.view showEmptyViewWithImage:[UIImage imageNamed:@"缺省插画_无作业"] title:@"暂无排行数据" centerYOffset:0 linkTitle:0 linkClickCallback:nil retryCallback:^{
                [weakSelf requestGetActivityRankList];
            }];
        } else {
            weakSelf.tableView.hidden = NO;
            weakSelf.headerView.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - 编辑活动
- (IBAction)editActivityAction:(id)sender {
    
    WeakifySelf;
    MICreateTaskViewController *createVC = [[MICreateTaskViewController alloc] init];
    [createVC setupCreateActivity:self.curActInfo];
    createVC.callBack = ^(BOOL isDelete) {
        if (isDelete) {
            self.currentActivityIndex = -1;
        }
        if (weakSelf.callback) {
            
            weakSelf.callback(self.currentActivityIndex);
        }
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma mark - 新建活动
- (void)createActivity{
    MICreateTaskViewController *createVC = [[MICreateTaskViewController alloc] init];
    [createVC setupCreateActivity:nil];
    WeakifySelf;
    createVC.callBack = ^(BOOL isDelete) {
        if (weakSelf.callback) {
            
            weakSelf.callback(-1);
        }
    };
    [self.navigationController pushViewController:createVC animated:YES];
}


- (void)updateRankListWithActivityModel:(ActivityInfo *_Nullable)model index:(NSInteger)currentIndex{
    
    self.curActInfo = model;
    self.currentActivityIndex =  currentIndex;
    if (model) {
        
        [self requestGetActivityRankList];
    } else {
        self.tableView.hidden = YES;
        self.headerView.hidden = YES;
    }
}

#pragma mark -
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.okRankArray.count + self.checkRankArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MIActivityRankListTableViewCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MIActivityRankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MIActivityRankListTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIActivityRankListTableViewCell class]) owner:nil options:nil] lastObject];
    }
    if (indexPath.row < self.okRankArray.count) {
        ActivityRankInfo *model = self.okRankArray[indexPath.row];
        [cell setupWithModel:model index:indexPath.row + 1];
    } else {
        
        ActivityRankInfo *model = self.checkRankArray[indexPath.row - self.okRankArray.count];
        [cell setupWithModel:model index:0];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityRankInfo *model;
    if (indexPath.row < self.okRankArray.count) {
        model = self.okRankArray[indexPath.row];
    } else {
        model = self.checkRankArray[indexPath.row - self.okRankArray.count];
    }
    MIParticipateDetailViewController *detailVC = [[MIParticipateDetailViewController alloc] init];
    detailVC.rankInfo = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (ActivityInfo *)curActInfo{
    
    if (!_curActInfo) {
        _curActInfo = [[ActivityInfo alloc] init];
    }
    return _curActInfo;
}
@end
