//
//  MIActivityRankListViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "ManagerServce.h"
#import "MICreateTaskViewController.h"
#import "MIActivityRankListTableViewCell.h"
#import "MIActivityRankListViewController.h"
#import "MIParticipateDetailViewController.h"
#import "UIViewController+PrimaryCloumnScale.h"

@interface MIActivityRankListViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) ActivityInfo *curActInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (strong, nonatomic) NSMutableArray *okRankArray;
@property (strong, nonatomic) NSMutableArray *checkRankArray;

@property (assign, nonatomic) NSInteger currentActivityIndex;

@property (assign, nonatomic) NSInteger currentSelectedIndex;

@end

@implementation MIActivityRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureUI];
    
}

- (void)configureUI{
    
    self.currentSelectedIndex = -1;
    self.okRankArray = [NSMutableArray array];
    self.checkRankArray = [NSMutableArray array];
    
    self.headerView.hidden = YES;
    self.tableView.hidden = YES;
    self.view.backgroundColor = [UIColor unSelectedColor];
    
    self.editBtn.layer.borderColor = [UIColor mainColor].CGColor;
    self.editBtn.layer.borderWidth = 0.5;
    self.editBtn.layer.cornerRadius = 4.0;
    self.editBtn.layer.masksToBounds = YES;
    
  
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
 
    [self showCreateListVC:NO];
}

#pragma mark - 新建活动
- (void)createActivity{
    
    [self showCreateListVC:YES];
}

- (void)showCreateListVC:(BOOL)isCreate{
    
    __block  UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MICreateTaskViewController *createVC = [[MICreateTaskViewController alloc] init];
    
    [createVC setupCreateActivity: (isCreate) ? nil : self.curActInfo];
    WeakifySelf;
    createVC.callBack = ^(BOOL isDelete) {
        if (isCreate) {
            
            if (weakSelf.callback) {
                weakSelf.callback(-1);
            }
        } else {
            if (isDelete) {
                self.currentActivityIndex = -1;
            }
            if (weakSelf.callback) {
                weakSelf.callback(weakSelf.currentActivityIndex);
            }
        }
        if (bgView.superview) {
            [bgView removeFromSuperview];
        }
    };
    createVC.cancelCallBack = ^{
        
        if (bgView.superview) {
            [bgView removeFromSuperview];
        }
    };
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIViewController *rootVC = self.view.window.rootViewController;
    if (rootVC) {
        [rootVC.view addSubview:bgView];
    }
    [bgView addSubview:createVC.view];
    createVC.view.frame = CGRectMake(kRootModularWidth/2.0, 70, ScreenWidth - kRootModularWidth, ScreenHeight - 120);
}

- (void)updateRankListWithActivityModel:(ActivityInfo *_Nullable)model index:(NSInteger)currentIndex{
    
    self.curActInfo = model;
    self.currentActivityIndex =  currentIndex;
    self.currentSelectedIndex = -1;
    if (model) {
        [self requestGetActivityRankList];
        self.rightLineView.hidden = NO;
        self.view.backgroundColor = [UIColor unSelectedColor];
    } else {
        [self.view hideAllStateView];
        self.tableView.hidden = YES;
        self.headerView.hidden = YES;
        self.rightLineView.hidden = YES;
        self.view.backgroundColor = [UIColor emptyBgColor];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.okRankArray.count) {
        ActivityRankInfo *model = self.okRankArray[indexPath.row];
        [cell setupWithModel:model index:indexPath.row + 1];
    } else {
        
        ActivityRankInfo *model = self.checkRankArray[indexPath.row - self.okRankArray.count];
        [cell setupWithModel:model index:0];
    }
    [cell setSelectedState:(self.currentSelectedIndex == indexPath.row) ? YES : NO];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentSelectedIndex == indexPath.row) {
        return;
    }
    self.currentSelectedIndex = indexPath.row;
    [tableView reloadData];
    
    ActivityRankInfo *model;
    if (indexPath.row < self.okRankArray.count) {
        model = self.okRankArray[indexPath.row];
    } else {
        model = self.checkRankArray[indexPath.row - self.okRankArray.count];
    }
    MIParticipateDetailViewController *detailVC = [[MIParticipateDetailViewController alloc] init];
    detailVC.rankInfo = model;
    WeakifySelf;
    detailVC.correctCallBack = ^{
        [weakSelf requestGetActivityRankList];
    };
    detailVC.cancelCallBack = ^{
        weakSelf.currentSelectedIndex = -1;
        [weakSelf.tableView reloadData];
    };
    if (self.pushVCCallback) {
        self.pushVCCallback(detailVC);
    }
}


- (ActivityInfo *)curActInfo{
    
    if (!_curActInfo) {
        _curActInfo = [[ActivityInfo alloc] init];
    }
    return _curActInfo;
}
@end
