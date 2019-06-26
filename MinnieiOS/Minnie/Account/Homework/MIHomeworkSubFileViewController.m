//
//  MIHomeworkSubFileViewController.m
//  Minnie
//
//  Created by songzhen on 2019/6/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "UIView+Load.h"
#import "MIAddTypeTableViewCell.h"
#import "MIHomeworkTaskListViewController.h"
#import "MIHomeworkSubFileViewController.h"

@interface MIHomeworkSubFileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MIHomeworkSubFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.parentFileInfo.fileInfo.fileName;
    self.tableView.separatorColor = [UIColor separatorLineColor];
    self.tableView.backgroundColor = [UIColor bgColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MIAddTypeTableViewCell" bundle:nil] forCellReuseIdentifier:MIAddTypeTableViewCellId];
    if (self.parentFileInfo.subFileList.count == 0) {
        [self.tableView showEmptyViewWithImage:nil title:@"文件夹为空" linkTitle:nil linkClickCallback:nil];
    }
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelagete
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MIAddTypeTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.parentFileInfo.subFileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIAddTypeTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:MIAddTypeTableViewCellId forIndexPath:indexPath];

    FileInfo *subFileInfo = self.parentFileInfo.subFileList[indexPath.row];
    [contentCell setupWithContentTitle:subFileInfo.fileName];
    return contentCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MIHomeworkTaskListViewController *subVC = [[MIHomeworkTaskListViewController alloc] initWithNibName:NSStringFromClass([MIHomeworkTaskListViewController class]) bundle:nil];
    FileInfo *subFileInfo = self.parentFileInfo.subFileList[indexPath.row];
    subVC.currentFileInfo = subFileInfo;
    [self.navigationController pushViewController:subVC animated:YES];
}

@end
