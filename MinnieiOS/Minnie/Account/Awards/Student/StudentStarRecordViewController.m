//
//  StudentStarRecordViewController.m
//  MinnieStudent
//
//  Created by songzhen on 2019/4/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "UIView+Load.h"
#import "StudentAwardService.h"
#import "UIScrollView+Refresh.h"
#import "StudentStarRecordViewController.h"

@interface StudentStarRecordViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BaseRequest * rankRequest;

@property (nonatomic, strong) NSMutableArray *recordArray;


@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation StudentStarRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordArray = [[NSMutableArray alloc] init];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    _pageNum = 20;
    _currentIndex = 1;
    // 下拉刷新
    [self.tableView addPullToRefreshWithTarget:self refreshingAction:@selector(refresh)];
    
    // 上拉加载
    [self.tableView addInfiniteScrollingWithTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView headerBeginRefreshing];
}

- (void)refresh{
    
    _currentIndex = 1;
    [self requestStarRecordList:YES];
}

- (void)loadMore{
    
    _currentIndex++;
    [self requestStarRecordList:NO];

}
- (void)requestStarRecordList:(BOOL)isRefresh
{

    self.tableView.hidden = YES;
    self.rankRequest = [StudentAwardService requestStarLogsWithPageNo:_currentIndex pageNum:_pageNum callback:^(Result *result, NSError *error) {
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self handleStarRankResult:result error:error isRefresh:isRefresh];
    }];
    
}
- (void)handleStarRankResult:(Result *)result error:(NSError *)error isRefresh:(BOOL)isRefresh
{
    [self.rankRequest clearCompletionBlock];
    self.rankRequest = nil;
    [self.view hideAllStateView];
    
    if (error != nil && self.recordArray.count == 0) {
        WeakifySelf;
        [self.view showFailureViewWithRetryCallback:^{
            [weakSelf requestStarRecordList:YES];
        }];
        return;
    }
    StarLogs * resultLogs= (StarLogs*)result.userInfo;
    if (isRefresh) {
        
        [self.recordArray removeAllObjects];
    }
    [self.recordArray addObjectsFromArray:resultLogs.list];
    if (!resultLogs.list.count) {
        [self.tableView footerNoticeNoMoreData];
    }
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    if (self.recordArray.count < _pageNum) {
        
        [self.tableView setFooterHidden:YES];
    } else {
        [self.tableView setFooterHidden:NO];
    }
    
}
- (IBAction)backClicked:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource && UITableViewDelagete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recordArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DayStarLogDetail *logDetail = self.recordArray[section];
    return logDetail.starLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
        cell.detailTextLabel.textColor = [UIColor colorWithHex:0x666666];
    }
    DayStarLogDetail *dayLogDetail = self.recordArray[indexPath.section];
    StarLogDetail *logDetail = dayLogDetail.starLogs[indexPath.row];
    cell.textLabel.text = logDetail.starLogDesc;
    cell.detailTextLabel.text = logDetail.starCount;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *headerView =  [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHex:0XF5F5F5];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth - 120, 16)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont boldSystemFontOfSize:16];
    timeLabel.textColor = [UIColor colorWithHex:0x999999];
    [headerView addSubview:timeLabel];
    
    CGFloat rightWidth = 20;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        rightWidth = 15;
    }
    UILabel *startCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 60 - rightWidth, 5, 60, 16)];
    startCountLabel.textAlignment = NSTextAlignmentRight;
    startCountLabel.font = [UIFont boldSystemFontOfSize:14];
    startCountLabel.textColor = [UIColor colorWithHex:0x999999];
    [headerView addSubview:startCountLabel];
    DayStarLogDetail *dayLogDetail = self.recordArray[section];
    timeLabel.text = dayLogDetail.starLogDate;
    startCountLabel.text = dayLogDetail.dayStarSum;
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 26;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
