//
//  StudentStarListViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StudentStarListViewController.h"
#import "StudentStarListTableViewCell.h"
#import "StudentAwardService.h"
NSString * const StudentStarListTableViewCellId = @"StudentStarListTableViewCellId";

@interface StudentStarListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation StudentStarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellNibs];
    
    [self requestStarList];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerCellNibs {
    [self.mTableView registerNib:[UINib nibWithNibName:@"StudentStarListTableViewCell" bundle:nil] forCellReuseIdentifier:StudentStarListTableViewCellId];
}

- (void)requestStarList
{
    [StudentAwardService requestStudentStarRankListWithCallback:^(Result *result, NSError *error) {
        
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentStarListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StudentStarListTableViewCellId forIndexPath:indexPath];
    return cell;
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
