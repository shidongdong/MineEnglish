//
//  MIActivityRankListViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ManagerServce.h"
#import "MICreateHomeworkTaskView.h"
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

@property (strong, nonatomic) NSMutableArray *participateArray;

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
    self.participateArray = [NSMutableArray array];
  
    UIView *footrView = [[UIView alloc] init];
    footrView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footrView;
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

- (void)updateRankListWithActivityModel:(ActivityInfo *_Nullable)model index:(NSInteger)currentIndex{
   
    self.curActInfo = model;
    self.currentActivityIndex =  currentIndex;
    
    [self.participateArray removeAllObjects];
    
    ActivityRankInfo *listInfo = [[ActivityRankInfo alloc] init];
    listInfo.nickName = @"哈哈哈哈";
    [self.participateArray addObject:listInfo];
    //请求排名列表
    if (self.participateArray.count) {
        
        self.tableView.hidden = NO;
        self.headerView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
        self.headerView.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark -
- (void)request{
    
    [ManagerServce requestGetActivityRankListWithActId:self.curActInfo.activityId callback:^(Result *result, NSError *error) {
        
    }];
}

- (IBAction)editActivityAction:(id)sender {
    
    MICreateHomeworkTaskView *createTaskView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MICreateHomeworkTaskView class]) owner:nil options:nil].lastObject;
    createTaskView.frame = [UIScreen mainScreen].bounds;
    WeakifySelf;
    createTaskView.callBack = ^{
        
        if (weakSelf.callback) {
            
            weakSelf.callback(weakSelf.currentActivityIndex);
        }
    };
    [createTaskView setupCreateHomework:nil taskType:MIHomeworkTaskType_Activity];
    [[UIApplication sharedApplication].keyWindow addSubview:createTaskView];
}

#pragma mark -
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.participateArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MIActivityRankListTableViewCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MIActivityRankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MIActivityRankListTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIActivityRankListTableViewCell class]) owner:nil options:nil] lastObject];
    }
    ActivityRankInfo *model = self.participateArray[indexPath.row];
    [cell setupWithModel:model index:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MIParticipateDetailViewController *detailVC = [[MIParticipateDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
