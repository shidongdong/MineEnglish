//
//  MIZeroMessagesViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/12.
//  Copyright © 2019 minnieedu. All rights reserved.
//


#import "StudentService.h"
#import "MIZeroMessagesTableViewCell.h"
#import "MIZeroMessagesViewController.h"

@interface MIZeroMessagesViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *zeroMessagesArray;
@end

@implementation MIZeroMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
    self.zeroMessagesArray = [NSMutableArray array];
    [self requestStudentZeroTask];
}


#pragma mark -   UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.zeroMessagesArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
    
        return 30;
    } else {
    
        StudentZeroTask * zeroTaskData = self.zeroMessagesArray[indexPath.row - 1];
        return [MIZeroMessagesTableViewCell cellHeightWithZeroMessage:zeroTaskData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MIZeroMessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MIZeroMessagesTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MIZeroMessagesTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        
        [cell setupImage:@""
                    name:@"名字"
               taskTitle:@"任务"
                 comment:@"评语"
                 teacher:@"对象"
                   index:0];
    } else {
        
        StudentZeroTask * zeroTaskData = self.zeroMessagesArray[indexPath.row - 1];
        [cell setupImage:zeroTaskData.avatar
                    name:zeroTaskData.nickName
               taskTitle:zeroTaskData.title
                 comment:zeroTaskData.content
                 teacher:zeroTaskData.createTeacher
                   index:indexPath.row];
    }
    return cell;
}

- (void)updateZeroMessages{
    
    [self requestStudentZeroTask];
}
- (void)requestStudentZeroTask{
    
    if (self.zeroMessagesArray.count == 0) {
        self.tableView.hidden = YES;
        [self.view showLoadingView];
    }
    WeakifySelf;
    [StudentService requestStudentZeroTaskCallback:^(Result *result, NSError *error) {
        [weakSelf.view hideAllStateView];
        if (error) {
            if (weakSelf.zeroMessagesArray.count == 0) {
              
                [weakSelf.view showFailureViewWithRetryCallback:^{
                    [weakSelf requestStudentZeroTask];
                }];
            }
            return ;
        } ;
        
        NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
        [self.zeroMessagesArray removeAllObjects];
        [self.zeroMessagesArray addObjectsFromArray:dictionary[@"list"]];
        if (weakSelf.zeroMessagesArray.count == 0) {
            
            [weakSelf.view showEmptyViewWithImage:nil
                                            title:@"暂无零分动态"
                                    centerYOffset:0 linkTitle:nil
                                linkClickCallback:nil
                                    retryCallback:^{
                
                                        [weakSelf requestStudentZeroTask];
                                    }];
        } else {
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
