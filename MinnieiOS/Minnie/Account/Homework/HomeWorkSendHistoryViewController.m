//
//  HomeWorkSendHistoryViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/27.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeWorkSendHistoryViewController.h"
#import "HomeworkSendHisTableViewCell.h"
@interface HomeWorkSendHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation HomeWorkSendHistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    return 10;
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
