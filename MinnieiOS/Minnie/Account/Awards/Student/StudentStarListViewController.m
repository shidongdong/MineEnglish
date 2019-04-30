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
@end

@implementation StudentStarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rankList = [[NSMutableArray alloc] init];
    
    [self registerCellNibs];
    
    [self requestStarList];
    [self footerView];
    // Do any additional setup after loading the view from its nib.
}

- (void)footerView{
    
    UIButton *startListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startListBtn setTitle:@"星星账单" forState: UIControlStateNormal];
    startListBtn.layer.masksToBounds = YES;
    startListBtn.layer.cornerRadius = 12.0;
    startListBtn.frame = CGRectMake(ScreenWidth/2.0 - 90, 20, 180, 44.0);
    
    [startListBtn setBackgroundColor:[UIColor colorWithHex:0X62C93D]];
    [startListBtn addTarget:self action:@selector(starListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64.0)];
    [footerView addSubview:startListBtn];
    footerView.backgroundColor = [UIColor clearColor];
    self.mTableView.tableFooterView = footerView;
}

- (void)starListBtnClicked:(UIButton *)btn{
    
    StudentStarRecordViewController * statRecordVC = [[StudentStarRecordViewController alloc] initWithNibName:NSStringFromClass([StudentStarRecordViewController class]) bundle:nil];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:statRecordVC animated:YES];
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
