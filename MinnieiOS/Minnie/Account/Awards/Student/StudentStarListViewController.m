//
//  StudentStarListViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StarRank.h"
#import "UIView+Load.h"
#import "StudentAwardService.h"
#import "StudentStarListViewController.h"
#import "StudentStarListTableViewCell.h"
#import "StudentStarRecordViewController.h"


NSString * const StudentStarListTableViewCellId = @"StudentStarListTableViewCellId";

@interface StudentStarListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray * rankList;
@property (nonatomic, strong) BaseRequest * rankRequest;
@property (weak, nonatomic) IBOutlet UIButton *starRecordBtn;
@end

@implementation StudentStarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rankList = [[NSMutableArray alloc] init];
    
    [self registerCellNibs];
    
    [self requestStarList];

    // Do any additional setup after loading the view from its nib.
}


- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)rightBtnAction:(id)sender {
    
    StudentStarRecordViewController * statRecordVC = [[StudentStarRecordViewController alloc] initWithNibName:NSStringFromClass([StudentStarRecordViewController class]) bundle:nil];
    statRecordVC.recordType = 0;
    [self.navigationController pushViewController:statRecordVC animated:YES];
}

- (void)registerCellNibs {
    [self.mTableView registerNib:[UINib nibWithNibName:@"StudentStarListTableViewCell" bundle:nil] forCellReuseIdentifier:StudentStarListTableViewCellId];
}

- (void)requestStarList
{
    [self.view showLoadingView];
    self.mTableView.hidden = YES;
    self.rankRequest = [StudentAwardService requestStudentStarRankListWithCallback:^(Result *result, NSError *error) {
        [self handleStarRankResult:result error:error];
    }];
}

- (void)handleStarRankResult:(Result *)result error:(NSError *)error
{
    [self.rankRequest clearCompletionBlock];
    self.rankRequest = nil;
    
    [self.view hideAllStateView];
    
    if (error != nil) {
        WeakifySelf;
        [self.view showFailureViewWithRetryCallback:^{
            [weakSelf requestStarList];
        }];
        
        return;
    }
    
    NSArray * resultList = (NSArray *)(result.userInfo);
    [self.rankList removeAllObjects];
    [self.rankList addObjectsFromArray:resultList];
    self.mTableView.hidden = NO;
    
    [self.mTableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentStarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentStarListTableViewCellId forIndexPath:indexPath];
    StarRank * data = [self.rankList objectAtIndex:indexPath.row];
    [cell setContentData:data forRank:indexPath.row];
    return cell;
}


#pragma mark - getter

- (NSMutableArray *)rankList
{
    if (!_rankList)
    {
        _rankList = [[NSMutableArray alloc] init];
    }
    return _rankList;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
