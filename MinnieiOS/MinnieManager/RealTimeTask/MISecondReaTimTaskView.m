//
//  MISecondReaTimTaskView.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "MISecondReaTimTaskView.h"
#import "MISecondReaTimeTaskTableViewCell.h"

@interface MISecondReaTimTaskView ()<
UITableViewDelegate,
UITableViewDataSource
>
// 当前选中
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) UITableView *tableView;
// 教师
@property (nonatomic,strong) NSMutableArray *teachersArray;

@end

@implementation MISecondReaTimTaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIndex = -1;
        _teachersArray = [NSMutableArray array];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, self.frame.size.width, self.frame.size.height - kNaviBarHeight)style:UITableViewStylePlain];
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
    
    return 4;
    return self.teachersArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MISecondReaTimeTaskTableViewCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MISecondReaTimeTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MISecondReaTimeTaskTableViewCellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MISecondReaTimeTaskTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_currentIndex == indexPath.row) {
        
        [cell setupTitle:@"教师名字" icon:@"" selectState:YES];
    } else {
        
        [cell setupTitle:@"教师名字" icon:@"" selectState:NO];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentIndex = indexPath.row;
    [tableView reloadData];
}


@end
