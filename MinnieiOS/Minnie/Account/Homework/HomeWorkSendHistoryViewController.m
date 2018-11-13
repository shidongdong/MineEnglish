//
//  HomeWorkSendHistoryViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/27.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeWorkSendHistoryViewController.h"
#import "HomeworkSendHisTableViewCell.h"
#import "HomeworkService.h"
#import "UIScrollView+Refresh.h"
#import "UIView+Load.h"
@interface HomeWorkSendHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic, copy)NSString * nextUrl;
@property (nonatomic, strong)BaseRequest * hitoryRequest;
@property (nonatomic, strong)NSMutableArray * homeworks;
@end

@implementation HomeWorkSendHistoryViewController

- (void)dealloc
{
    [self.hitoryRequest clearCompletionBlock];
    [self.hitoryRequest stop];
    self.hitoryRequest = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.homeworks = [NSMutableArray array];
    [self registerNibCell];
    [self requestHistoryList];
    // Do any additional setup after loading the view from its nib.
}

- (void)registerNibCell
{
    [self.mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkSendHisTableViewCell class]) bundle:nil] forCellReuseIdentifier:HomeworkSendHisTableViewCellId];
}

- (void)requestHistoryList
{
    if (self.hitoryRequest != nil) {
        return;
    }
    
    if (self.homeworks.count == 0) {
        [self.view showLoadingView];
        self.mTableView.hidden = YES;
    }
    
    WeakifySelf;
     self.hitoryRequest = [HomeworkService requestSendHomeworkHistoryWithCallback:^(Result *result, NSError *error) {
        [weakSelf handleHomeworkHistoryResult:result error:error];
    }];
}

- (void)handleHomeworkHistoryResult:(Result *)result error:(NSError *)error {
    self.hitoryRequest = nil;
    
    [self.view hideAllStateView];
    
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSString *nextUrl = dictionary[@"next"];
    NSArray *homeworks = dictionary[@"list"];
    
    BOOL isLoadMore = self.nextUrl.length > 0;
    if (isLoadMore) {
        [self.mTableView footerEndRefreshing];
        self.mTableView.hidden = NO;
        
        if (error != nil) {
            return;
        }
        
        if (homeworks.count > 0) {
            [self.homeworks addObjectsFromArray:homeworks];
        }
        
        if (nextUrl.length == 0) {
            [self.mTableView removeFooter];
        }
        
        [self.mTableView reloadData];
    } else {
        // 停止加载
        [self.mTableView headerEndRefreshing];
        self.mTableView.hidden = homeworks.count==0;
        
        if (error != nil) {
            if (homeworks.count > 0) {
                [TIP showText:@"加载失败" inView:self.view];
            } else {
                WeakifySelf;
                [self.view showFailureViewWithRetryCallback:^{
                    [weakSelf requestHistoryList];
                }];
            }
            
            return;
        }
        
        if (homeworks.count > 0) {
            self.mTableView.hidden = NO;
            
            [self.homeworks addObjectsFromArray:homeworks];
            [self.mTableView reloadData];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.mTableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMoreHomeworks];
                }];
            } else {
                [self.mTableView removeFooter];
            }
        } else {
            [self.view showEmptyViewWithImage:nil
                                                 title:@"无相关发送记录"
                                         centerYOffset:0
                                             linkTitle:nil
                                     linkClickCallback:nil];
        }
    }
    
    self.nextUrl = nextUrl;
}

- (void)loadMoreHomeworks {
    if (self.hitoryRequest != nil) {
        return;
    }
    
    WeakifySelf;
    self.hitoryRequest = [HomeworkService requestSendHomeworkHistoryWithNextUrl:self.nextUrl callback:^(Result *result, NSError *error) {
        [weakSelf handleHomeworkHistoryResult:result error:error];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeworks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeworkSendHisTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HomeworkSendHisTableViewCellId forIndexPath:indexPath];
    return cell;
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
