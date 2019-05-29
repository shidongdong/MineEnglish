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
    
    NSArray *titleArray = @[@"实时任务",
                            @"教师管理",
                            @"任务管理",
                            @"教学统计",
                            @"校区管理",
                            @"礼物管理",
                            @"设置"];
    NSArray *selectImage = @[@"navbar_setup_select",
                             @"navbar_setup_select",
                             @"navbar_setup_select",
                             @"navbar_setup_select",
                             @"navbar_setup_select",
                             @"navbar_setup_select",
                             @"navbar_setup_select"];
    NSArray *normalImage = @[@"navbar_setup_normal",
                             @"navbar_setup_normal",
                             @"navbar_setup_normal",
                             @"navbar_setup_normal",
                             @"navbar_setup_normal",
                             @"navbar_setup_normal",
                             @"navbar_setup_normal"];
    
    self.btns = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        
        NSString *title = titleArray[i];
        NSString *selectImg = selectImage[i];
        NSString *normalImg = normalImage[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1500 + i;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor detailColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor mainColor] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 上左下
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 24, 0)];
        // 上右下
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(32, -30, 0, -12)];
        [self addSubview:btn];
        // 设置
        if (i == 6) { 
            btn.frame = CGRectMake(11, [UIScreen mainScreen].bounds.size.height - 90, 48, 50);
        } else {
          
            CGFloat pointY = kNaviBarHeight + (36 + 50) * i;
            btn.frame = CGRectMake(20, pointY, 48, 50);
        }
        [self.btns addObject:btn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kRootModularWidth - 1.0, 0, 1.0, [UIScreen mainScreen].bounds.size.height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

- (void)btnClicked:(UIButton *)selectBtn{
    
    NSInteger selectIndex = selectBtn.tag - 1500;
    if (selectIndex == 2 || selectIndex == 6) {
        
    } else {
        return;
    }
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    selectBtn.selected = YES;
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(rootSheetViewClickedIndex:)]) {
        
        [self.delegate rootSheetViewClickedIndex:selectIndex];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    
    _selectIndex = selectIndex;
    
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
        if (btn.tag - 1500 == _selectIndex) {
            
            btn.selected = YES;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rootSheetViewClickedIndex:)]) {
        
        [self.delegate rootSheetViewClickedIndex:selectIndex];
    }
}

@end
