//
//  StudentStarRecordViewController.m
//  MinnieStudent
//
//  Created by songzhen on 2019/4/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "StudentStarRecordViewController.h"

@interface StudentStarRecordViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation StudentStarRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backClicked:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource && UITableViewDelagete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"任务获得星星xxxxx%ld",indexPath.row];
    cell.detailTextLabel.text = @"+2222";
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *headerView =  [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHex:0XF5F5F5];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, ScreenWidth - 120, 16)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont boldSystemFontOfSize:16];
    timeLabel.textColor = [UIColor blackColor];
    [headerView addSubview:timeLabel];
    
    UILabel *startCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 5, 60, 16)];
    startCountLabel.textAlignment = NSTextAlignmentRight;
    startCountLabel.font = [UIFont boldSystemFontOfSize:14];
    startCountLabel.textColor = [UIColor blackColor];
    [headerView addSubview:startCountLabel];
    
    timeLabel.text = @"2019年4月29日";
    startCountLabel.text = @"+1500";
    
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
