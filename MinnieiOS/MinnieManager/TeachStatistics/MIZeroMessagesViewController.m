//
//  MIZeroMessagesViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/12.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIZeroMessagesTableViewCell.h"
#import "MIZeroMessagesViewController.h"

@interface MIZeroMessagesViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MIZeroMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark -   UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
    
        return 30;
    } else {
       
        return 56;
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
        [cell setupImage:@""
                    name:@"名字名字"
               taskTitle:@"任务任务任务任务任务任务任务任务任务"
                 comment:@"评语评语评语评语评语评语评语评语评语评语评语评语评语评语评语评语评语评语"
                 teacher:@"对象对象"
                   index:indexPath.row];
    }
    return cell;
}

@end
