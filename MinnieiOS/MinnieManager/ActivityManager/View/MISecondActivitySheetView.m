//
//  MISecondActivitySheetView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "ManagerServce.h"
#import "MISecondActivitySheetView.h"
#import "MISecondActivityTableViewCell.h"

@interface MISecondActivitySheetView ()<
UITableViewDelegate,
UITableViewDataSource
>

// 当前选中
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UITableView *tableView;
// 活动列表
@property (nonatomic,strong) NSMutableArray *activityArray;

@end

@implementation MISecondActivitySheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIndex = -1;
        _activityArray = [NSMutableArray array];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    UIButton *addActivitybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addActivitybtn setTitle:@"创建" forState:UIControlStateNormal];
    addActivitybtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addActivitybtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];

    [addActivitybtn addTarget:self action:@selector(addActivityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addActivitybtn];
    addActivitybtn.frame = CGRectMake(10, 70 - 35, 80, 28);
    addActivitybtn.layer.borderColor = [UIColor mainColor].CGColor;
    addActivitybtn.layer.borderWidth = 0.5;
    addActivitybtn.layer.cornerRadius = 4.0;
    addActivitybtn.layer.masksToBounds = YES;
    
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake( 0, kNaviBarHeight - 1, kColumnSecondWidth, 1.0)];
//    lineView1.backgroundColor = [UIColor separatorLineColor];
//    [self addSubview:lineView1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height - 70)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.separatorColor = [UIColor separatorLineColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kColumnSecondWidth - 0.5, 0, 0.5, [UIScreen mainScreen].bounds.size.height)];
    lineView.backgroundColor = [UIColor separatorLineColor];
    [self addSubview:lineView];
    
    UIView *footrView = [[UIView alloc] init];
    footrView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footrView;
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

#pragma mark -
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.activityArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MISecondActivityTableViewCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MISecondActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MISecondActivityTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MISecondActivityTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ActivityInfo *model = self.activityArray[indexPath.row];
    if (indexPath.row == _currentIndex) {
        [cell setupWithModel:model selected:YES];
    } else {
        [cell setupWithModel:model selected:NO];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActivityInfo *model = self.activityArray[indexPath.row];
    _currentIndex = indexPath.row;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondActivitySheetViewDidClickedActivity:index:)]) {
        
        [self.delegate secondActivitySheetViewDidClickedActivity:model index:indexPath.row];
    }
    [tableView reloadData];
}

#pragma mark -  新建一活动
- (void)addActivityBtnClicked:(UIButton *)addBtn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondActivitySheetViewCreateActivity)]) {
        [self.delegate secondActivitySheetViewCreateActivity];
    }
}

- (void)activitySheetDidEditIndex:(NSInteger)index{
    
    _currentIndex = index;
    [self requestGetActivityList];
}

- (void)resetCurrentIndex{
    
    self.currentIndex = -1;
    [self.tableView reloadData];
}

- (void)updateActivityListInfo{
    self.currentIndex = -1;
    [self requestGetActivityList];
}

#pragma mark - 请求活动列表
- (void)requestGetActivityList{
    WeakifySelf;
    [ManagerServce requestGetActivityListWithCallback:^(Result *result, NSError *error) {
        
        if (error) return ;
        NSDictionary *dictionary = (NSDictionary *)(result.userInfo);
        NSArray *list = dictionary[@"list"];
        [self.activityArray removeAllObjects];
        [self.activityArray addObjectsFromArray:list];
        
        ActivityInfo *model;
        if (weakSelf.currentIndex>= 0 && weakSelf.currentIndex < weakSelf.activityArray.count) {
            model = weakSelf.activityArray[weakSelf.currentIndex];
        } else {
            weakSelf.currentIndex = -1;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(secondActivitySheetViewDidClickedActivity:index:)]) {
            
            [self.delegate secondActivitySheetViewDidClickedActivity:model index:weakSelf.currentIndex];
        }
        [self.tableView reloadData];
    }];
}

@end
