//
//  RootSheetView.m
//  
//
//  Created by songzhen on 2019/5/27.
//

#import "MIRootSheetView.h"

@interface MIRootSheetView ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation MIRootSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:@{@"type":@(MIManagerFuncRealTaskModule),
                           @"title":@"实时任务",
                           @"select":@"menu_mission_sel",
                           @"normal":@"menu_mission_def"}];
    [dataArray addObject:@{@"type":@(MIManagerFuncTeacherModule),
                           @"title":@"教师管理",
                           @"select":@"menu_number_sel",
                           @"normal":@"menu_number_def"}];
    
    if (APP.currentUser.canManageHomeworks) {
        
        [dataArray addObject:@{@"type":@(MIManagerFuncTaskModule),
                               @"title":@"任务管理",
                               @"select":@"menu_mission_manage_sel",
                               @"normal":@"menu_mission_manage_def"}];
    }
    if (APP.currentUser.canManageActivity) {
    
        [dataArray addObject:@{@"type":@(MIManagerFuncActivityModule),
                               @"title":@"活动管理",
                               @"select":@"menu_activity_sel",
                               @"normal":@"menu_activity_def"}];
    }
    if (APP.currentUser.canManageStudents) {
        
        [dataArray addObject:@{@"type":@(MIManagerFuncTeachingModule),
                               @"title":@"教学统计",
                               @"select":@"menu_Statistics_sel",
                               @"normal":@"menu_Statistics_def"}];
    }
    if (APP.currentUser.canManageCampus) {
      
        [dataArray addObject:@{@"type":@(MIManagerFuncCampusModule),
                               @"title":@"校区管理",
                               @"select":@"menu_school_sel",
                               @"normal":@"menu_school_def"}];
    }
    if (APP.currentUser.canExchangeRewards) {
        
        [dataArray addObject:@{@"type":@(MIManagerFuncGiftsModule),
                               @"title":@"礼物管理",
                               @"select":@"menu_gift_sel",
                               @"normal":@"menu_gift_def"}];
    }
    
    
    [dataArray addObject:@{@"type":@(MIManagerFuncImagesModule),
                           @"title":@"首页管理",
                           @"select":@"menu_gift_sel",
                           @"normal":@"menu_gift_def"}];
    
    [dataArray addObject:@{@"type":@(MIManagerFuncSettingModule),
                           @"title":@"设置",
                           @"select":@"navbar_setup_select",
                           @"normal":@"navbar_setup_normal"}];
    
    
    self.btns = [NSMutableArray array];

    for (NSInteger i = 0; i < dataArray.count; i++) {
        
        NSDictionary *dict = dataArray[i];
        NSString *title = dict[@"title"];
        NSString *selectImg = dict[@"select"];
        NSString *normalImg = dict[@"normal"];
        MIManagerFuncModule type = ((NSNumber *)dict[@"type"]).integerValue;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1500 + type;
        [btn setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        // 设置
        if (type == MIManagerFuncSettingModule) {
            btn.frame = CGRectMake((kRootModularWidth - 50)/2.0, ScreenHeight - 60, 50, 50);
        } else {
            
            CGFloat pointY = 40 + (30 + 50) * i;
            btn.frame = CGRectMake((kRootModularWidth - 50)/2.0, pointY, 50, 50);
            
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:[UIColor detailColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
            // 上左下
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 24, 0)];
            // 上右下
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(32, -35, 0, -12)];
        }
        [self.btns addObject:btn];
    }
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kRootModularWidth - 1.0, 0, 0.5, ScreenHeight)];
    lineView.backgroundColor = [UIColor separatorLineColor];
    [self addSubview:lineView];
}

- (void)btnClicked:(UIButton *)selectBtn{
    
    MIManagerFuncModule selectType = selectBtn.tag - 1500;

    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    selectBtn.selected = YES;
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(rootSheetViewClickedType:)]) {
        
        [self.delegate rootSheetViewClickedType:selectType];
    }
}


- (void)setSelectType:(MIManagerFuncModule)selectType{
    
    _selectType = selectType;
    
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
        if (btn.tag - 1500 == _selectType) {
            
            btn.selected = YES;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rootSheetViewClickedType:)]) {
        
        [self.delegate rootSheetViewClickedType:_selectType];
    }
    
}

@end
