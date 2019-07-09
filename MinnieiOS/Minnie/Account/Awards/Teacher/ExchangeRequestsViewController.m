//
//  ExchangeRequestsViewController.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeRequestsViewController.h"
#import "ExchangeRequestTableViewCell.h"
#import "TeacherAwardService.h"
#import "UIView+Load.h"
#import "Constants.h"
#import "TIP.h"
#import "UIScrollView+Refresh.h"
#import "TeacherAwardsViewController.h"
//#import "CreateAwardViewController.h"
#import "UIColor+HEX.h"

@interface ExchangeRequestsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UITableView *requestsTableView;
@property (nonatomic, weak) IBOutlet UIButton *manageButton;
@property (weak, nonatomic) IBOutlet UIButton *recordHistoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) BaseRequest *listRequest;

@property (nonatomic, strong) NSMutableArray <ExchangeRecord *> *requests;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation ExchangeRequestsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requests = [NSMutableArray array];
    
#if MANAGERSIDE
   
    self.customTitleLabel.text = @"";
    self.manageButton.hidden = YES;
    self.recordHistoryBtn.hidden = YES;
    self.backButton.enabled = NO;
    [self.backButton setTitle:@"兑换列表" forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
#else
    
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    
    if (self.exchanged) {
        [self.customTitleLabel setText:@"兑换历史"];
        self.manageButton.hidden = YES;
        
        self.recordHistoryBtn.hidden = YES;
        
    } else {
        [self.customTitleLabel setText:@"星兑换"];
        self.manageButton.hidden = NO;
        
        self.recordHistoryBtn.hidden = NO;
    }
#endif
    
    [self registerCellNibs];
    [self requestData];
}

- (IBAction)recordHistoryClick:(UIButton *)sender {
    ExchangeRequestsViewController *vc = [[ExchangeRequestsViewController alloc] initWithNibName:@"ExchangeRequestsViewController" bundle:nil];
    
    vc.exchanged = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [self.listRequest clearCompletionBlock];
    [self.listRequest stop];
    self.listRequest = nil;
    
    NSLog(@"%s", __func__);
}

- (IBAction)manageButtonPressed:(id)sender {
    TeacherAwardsViewController *vc = [[TeacherAwardsViewController alloc] initWithNibName:@"TeacherAwardsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Method

- (void)registerCellNibs {
    [self.requestsTableView registerNib:[UINib nibWithNibName:@"ExchangeRequestTableViewCell" bundle:nil]
                 forCellReuseIdentifier:ExchangeRequestTableViewCellId];
}

- (void)requestData {
    if (self.listRequest != nil) {
        return;
    }
    
    self.requestsTableView.hidden = YES;
    [self.containerView showLoadingView];

    WeakifySelf;
    self.listRequest = [TeacherAwardService requestExchangeRequestsWithState:self.exchanged
                                                             callback:^(Result *result, NSError *error) {
                                                                 StrongifySelf;
                                                                 
                                                                 [strongSelf handleRequestResult:result error:error];
                                                             }];
}

- (void)loadMore {
    if (self.listRequest != nil) {
        return;
    }
    
    WeakifySelf;
    self.listRequest = [TeacherAwardService requestExchangeRequestsWithMoreUrl:self.nextUrl
                                                               callback:^(Result *result, NSError *error) {
                                                                   StrongifySelf;
                                                                   
                                                                   [strongSelf handleRequestResult:result error:error];
                                                               }];
}

- (void)handleRequestResult:(Result *)result error:(NSError *)error {
    self.listRequest = nil;
    
    [self.containerView hideAllStateView];
    
    NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
    NSString *nextUrl = dictionary[@"next"];
    NSArray *records = dictionary[@"list"];

//    if (!self.exchanged) {
//        nextUrl = nil;
//    }
    
    BOOL isLoadMore = self.nextUrl.length > 0;
    if (isLoadMore) {
        [self.requestsTableView footerEndRefreshing];
        self.requestsTableView.hidden = NO;

        if (error != nil) {
            return;
        }
        
        if (records.count > 0) {
            [self.requests addObjectsFromArray:records];
        }
        
        if (nextUrl.length == 0) {
            [self.requestsTableView removeFooter];
        }
        
        [self.requestsTableView reloadData];
    } else {
        // 停止加载
        [self.requestsTableView headerEndRefreshing];
        self.requestsTableView.hidden = records.count==0;
        
        if (error != nil) {
            if (records.count > 0) {
                [TIP showText:@"加载失败" inView:self.view];
            } else {
                WeakifySelf;
                [self.containerView showFailureViewWithRetryCallback:^{
                    [weakSelf requestData];
                }];
            }
            
            return;
        }
        
        if (records.count > 0) {
            self.requestsTableView.hidden = NO;
            
            [self.requests addObjectsFromArray:records];
            [self.requestsTableView reloadData];
            
            if (nextUrl.length > 0) {
                WeakifySelf;
                [self.requestsTableView addInfiniteScrollingWithRefreshingBlock:^{
                    [weakSelf loadMore];
                }];
            } else {
                [self.requestsTableView removeFooter];
            }
        } else {
            if (!self.exchanged) {
                [self.containerView showEmptyViewWithImage:nil
                                                     title:@"暂无兑换信息"
                                             centerYOffset:-20
                                                 linkTitle:@"兑换历史"
                                         linkClickCallback:^{
                                             [self recordHistoryClick:nil];
                                         }];
            } else {
                [self.containerView showEmptyViewWithImage:nil
                                                     title:@"暂无兑换信息"
                                             centerYOffset:-20
                                                 linkTitle:nil
                                         linkClickCallback:nil];
            }
        }
    }
    
    self.nextUrl = nextUrl;
}

- (void)giveAwardWithRequest:(ExchangeRecord *)request {
#if TEACHERSIDE
    if (!APP.currentUser.canExchangeRewards) {
        [HUD showErrorWithMessage:@"无操作权限"];
        return;
    }
#endif
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认兑换"
                                                                             message:@"请将礼物交给兑换的小朋友后确认"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [HUD showProgressWithMessage:@"正在兑换"];
                                                              
                                                              [TeacherAwardService giveAwardWithId:request.exchangeRequestId
                                                                                   callback:^(Result *result, NSError *error) {
                                                                                       if (error != nil) {
                                                                                           [HUD showErrorWithMessage:@"兑换失败"];
                                                                                           return;
                                                                                       }

                                                                                       [HUD showWithMessage:@"兑换成功"];
                                                                                       
                                                                                       [self.requests removeAllObjects];
                                                                                       self.nextUrl = nil;
                                                                                       
                                                                                       [self requestData];
                                                                                   }];
                                                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExchangeRequestTableViewCellId forIndexPath:indexPath];
    
    ExchangeRecord *exchangeRequest = self.requests[indexPath.row];
    exchangeRequest.state = self.exchanged?1:0;
    
    WeakifySelf;
    cell.exchangeCallback = ^{
        [weakSelf giveAwardWithRequest:exchangeRequest];
    };
    
    [cell setupWithExchangeRequest:exchangeRequest];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ExchangeRequestTableViewCellHeight;
}

@end

