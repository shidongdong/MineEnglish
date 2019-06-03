//
//  MISecondActivitySheetView.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ManagerServce.h"
#import "MICreateHomeworkTaskView.h"
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
    [addActivitybtn setTitleColor:[UIColor detailColor] forState:UIControlStateNormal];
    [addActivitybtn setImage:[UIImage imageNamed:@"ic_add_black"] forState:UIControlStateNormal];
    [addActivitybtn addTarget:self action:@selector(addActivityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addActivitybtn];
    addActivitybtn.frame = CGRectMake(10, kNaviBarHeight - 26, kActivitySheetWidth - 20, 16);

    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake( 0, kNaviBarHeight - 1, kActivitySheetWidth, 1.0)];
    lineView1.backgroundColor = [UIColor separatorLineColor];
    [self addSubview:lineView1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, self.frame.size.width, self.frame.size.height - kNaviBarHeight)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.separatorColor = [UIColor separatorLineColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kActivitySheetWidth - 1.0, 0, 1.0, [UIScreen mainScreen].bounds.size.height)];
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
    
    MICreateHomeworkTaskView *createTaskView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MICreateHomeworkTaskView class]) owner:nil options:nil].lastObject;
    createTaskView.frame = [UIScreen mainScreen].bounds;
    WeakifySelf;
    createTaskView.callBack = ^{
        
        static int actId = 100;
        actId ++;
        ActivityInfo *actInfo1 = [[ActivityInfo alloc] init];
        actInfo1.activityId = 2;
        actInfo1.title = @"活动标题2";
        actInfo1.startTime = @"6月12日";
        actInfo1.endTime = @"6月24日";
        actInfo1.status = 1;
        
        [weakSelf.activityArray addObject:actInfo1];
        weakSelf.currentIndex = weakSelf.activityArray.count - 1;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(secondActivitySheetViewDidClickedActivity:index:)]) {
            
            [weakSelf.delegate secondActivitySheetViewDidClickedActivity:actInfo1 index:weakSelf.currentIndex];
        }
        [weakSelf.tableView reloadData];
        [weakSelf requestCreateActivity:actInfo1];
    };
    [createTaskView setupCreateHomework:nil taskType:MIHomeworkTaskType_Activity];
    [[UIApplication sharedApplication].keyWindow addSubview:createTaskView];
}


- (void)activitySheetDidEditIndex:(NSInteger)index{
    
    _currentIndex = index;
    [_tableView reloadData];
}

- (void)updateActivityListInfo{
    
    _currentIndex = -1;
    ActivityInfo *actInfo = [[ActivityInfo alloc] init];
    actInfo.activityId = 1;
    actInfo.title = @"活动标题1";
    actInfo.startTime = @"6月12日";
    actInfo.endTime = @"6月18日";
    actInfo.status = 2;
    
    
    ActivityInfo *actInfo1 = [[ActivityInfo alloc] init];
    actInfo1.activityId = 2;
    actInfo1.title = @"活动标题2";
    actInfo1.startTime = @"6月12日";
    actInfo1.endTime = @"6月24日";
    actInfo1.status = 1;
    
    [self.activityArray addObject:actInfo];
    [self.activityArray addObject:actInfo1];
    
    [self.tableView reloadData];
//    [self requestGetActivityList];
}

#pragma mark - 请求活动列表
- (void)requestGetActivityList{
    
    [ManagerServce requestGetActivityListWithCallback:^(Result *result, NSError *error) {
        
        
    }];
}

#pragma mark - 新建活动
- (void)requestCreateActivity:(ActivityInfo *)actInfo{
    
    [ManagerServce requestCreateActivity:actInfo callback:^(Result *result, NSError *error) {
        
        
    }];
}


@end
