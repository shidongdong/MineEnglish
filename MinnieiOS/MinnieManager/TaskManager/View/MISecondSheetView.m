//
//  SecondSheetView.m
//  Manager
//
//  Created by songzhen on 2019/5/27.
//  Copyright © 2019 songzhen. All rights reserved.
//

#import "MISecondSheetView.h"
#import "MICreateFolderView.h"
#import "MIHeaderTableViewCell.h"

@interface MISecondSheetView ()<
HeaderViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *tableView;

// 任务分类数组
@property (nonatomic,strong) NSMutableArray *taskTypeArray;

// 当前选中的二级文件夹 -1为未选中任何文件夹
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation MISecondSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIndex = -1;
        _taskTypeArray = [NSMutableArray array];
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    UIButton *addFolderbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFolderbtn setTitle:@"文件夹" forState:UIControlStateNormal];
    addFolderbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addFolderbtn setTitleColor:[UIColor detailColor] forState:UIControlStateNormal];
    [addFolderbtn setImage:[UIImage imageNamed:@"ic_add_black"] forState:UIControlStateNormal];
    [addFolderbtn addTarget:self action:@selector(addFolderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addFolderbtn];
    addFolderbtn.frame = CGRectMake(10, kNaviBarHeight - 26, (kFolderModularWidth - 20)/2.0, 16);
    
    UIButton *recordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordbtn setTitle:@"发送记录" forState:UIControlStateNormal];
    recordbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [recordbtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [recordbtn addTarget:self action:@selector(recordbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recordbtn];
    recordbtn.frame = CGRectMake((kFolderModularWidth)/2.0, kNaviBarHeight - 26, (kFolderModularWidth - 20)/2.0, 16);
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake( 0, kNaviBarHeight - 1, kFolderModularWidth, 1.0)];
    lineView1.backgroundColor = [UIColor separatorLineColor];
    [self addSubview:lineView1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, self.frame.size.width, self.frame.size.height)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.separatorColor = [UIColor separatorLineColor];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kFolderModularWidth - 1.0, 0, 1.0, [UIScreen mainScreen].bounds.size.height)];
    lineView.backgroundColor = [UIColor separatorLineColor];
    [self addSubview:lineView];

    UIView *footrView = [[UIView alloc] init];
    footrView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footrView;
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.taskTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MIFirLevelFolderModel *model = self.taskTypeArray[section];
    if (model.isOpen) {
        return model.folderArray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MISecondSheetViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor detailColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    MIFirLevelFolderModel *model = self.taskTypeArray[indexPath.section];
    MISecLevelFolderModel *secModel = model.folderArray[indexPath.row];
    if (indexPath.row == _currentIndex) {
        cell.textLabel.textColor = [UIColor mainColor];
    } else {
        cell.textLabel.textColor = [UIColor detailColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"   %@",secModel.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MIFirLevelFolderModel *model = self.taskTypeArray[indexPath.section];
    _currentIndex = indexPath.row;
    // 任务管理二级文件夹
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondSheetViewSecondLevelData:index:)]) {
        
        [self.delegate secondSheetViewSecondLevelData:model index:indexPath.row];
    }
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    MIHeaderTableViewCell *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MIHeaderTableViewCell" owner:self options:nil] lastObject];
    headerView.frame = view.bounds;
    headerView.delegate = self;
    headerView.typeModel = self.taskTypeArray[section];
    headerView.section = section;
    headerView.tag = 1000+section;
    [view addSubview:headerView];
    return view;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {// 删除
        
        MIFirLevelFolderModel *typeModel = self.taskTypeArray[indexPath.section];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:typeModel.folderArray];
        if (indexPath.row < temp.count) {
           
            [temp removeObjectAtIndex:indexPath.row];
        }
        typeModel.folderArray = temp;
        if (typeModel.folderArray.count == 0) {// 无子文件夹
            typeModel.isOpen = NO;
        }
        [_tableView reloadData];
    }
}

#pragma mark -  HeaderViewDelegate  一级文件展开折叠
- (void)headerViewDidCellClicked:(NSInteger)index{
    
    MIFirLevelFolderModel *model = self.taskTypeArray[index];
    if (model.folderArray.count == 0) {
        model.isOpen = YES;
    } else {
        model.isOpen = !model.isOpen;
    }
    
    // 点击一级文件夹，折叠其他文件夹
    [self collapseFolders:model];
   
    _currentIndex = -1;
    [_tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondSheetViewFirstLevelData:index:)]) {
        
        [self.delegate secondSheetViewFirstLevelData:model index:index];
    }
}

- (void)recordbtnClicked:(UIButton *)btn{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(toSendRecord)]) {
        
        [self.delegate toSendRecord];
    }
    
}
#pragma mark -  新建一级文件夹
- (void)addFolderBtnClicked:(UIButton *)addBtn{
    
    MICreateFolderView *createView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MICreateFolderView class]) owner:nil options:nil] lastObject];
    WeakifySelf;
    createView.sureCallBack = ^(NSString * _Nullable name) {
        
        // 添加文件夹
        MIFirLevelFolderModel *model = [[MIFirLevelFolderModel alloc] init];
        model.title = name;
        [weakSelf.taskTypeArray addObject:model];
        
        // 添加二级文件夹后打开当前一级文件夹
        model.isOpen = YES;
        [weakSelf collapseFolders:model];
        weakSelf.currentIndex = -1;
        [weakSelf.tableView reloadData];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(secondSheetViewFirstLevelData:index:)]) {
            
            [weakSelf.delegate secondSheetViewFirstLevelData:model index:weakSelf.taskTypeArray.count - 1];
        }
    };
    createView.titleName = @"添加父级文件夹";
    createView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:createView];
}

#pragma mark - 新建二级文件夹
- (void)headerViewAddClicked:(NSInteger)index{
    MICreateFolderView *createView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MICreateFolderView class]) owner:nil options:nil] lastObject];
    WeakifySelf;
    createView.sureCallBack = ^(NSString * _Nullable name) {
        
        // 添加子文件夹
        MIFirLevelFolderModel *model = weakSelf.taskTypeArray[index];
        NSMutableArray *folder = [NSMutableArray arrayWithArray:model.folderArray];
        MISecLevelFolderModel * secFolder = [[MISecLevelFolderModel alloc] init];
        secFolder.title = name;
        [folder addObject:secFolder];
        model.folderArray = folder;
        
        // 添加二级文件夹后打开当前一级文件夹
        model.isOpen = YES;
        [self collapseFolders:model];
        
        weakSelf.currentIndex = folder.count - 1;
        [weakSelf.tableView reloadData];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(secondSheetViewSecondLevelData:index:)]) {
            
            [weakSelf.delegate secondSheetViewSecondLevelData:model index:index];
        }
    };
    createView.titleName = @"添加子文件夹";
    createView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:createView];
}

- (void)addSecondLevelFolderIndex:(NSInteger)index{
    
    [self headerViewAddClicked:index];
}


#pragma mark - 折叠其他文件夹
- (void)collapseFolders:(MIFirLevelFolderModel *)model{
    
    // 其他文件夹折叠
    for (MIFirLevelFolderModel *firModel in self.taskTypeArray) {
        
        if (![model isEqual:firModel]) {
            
            firModel.isOpen = NO;
        }
        for (MISecLevelFolderModel *secModel in firModel.folderArray) {
            secModel.isSelected = NO;
        }
    }
}

- (void)updateData:(NSArray *)taskArray{
    
    [self.taskTypeArray  removeAllObjects];
    [self.taskTypeArray addObjectsFromArray:taskArray];
    [_tableView reloadData];
}

@end
