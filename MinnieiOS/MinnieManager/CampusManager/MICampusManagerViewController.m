//
//  MICampusManagerViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/11.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Result.h"
#import "ManagerServce.h"
#import "WMPageController.h"
#import "MIClassDetailViewController.h"
#import "MICampusManagerViewController.h"

@interface MICampusManagerViewController ()<
WMPageControllerDelegate,
WMPageControllerDataSource,
MIClassDetailViewControllerDelegate
>

@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, strong) NSArray *subPageTitleArray;
@property (nonatomic, strong) NSMutableArray *campusInfoArray;
@property (nonatomic, strong) NSMutableArray *subPageVCArray;

@property (nonatomic, strong) WMPageController *pageController;

@property (nonatomic, assign) NSInteger preIndex;

@end

@implementation MICampusManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.subPageVCArray = [NSMutableArray array];
    self.campusInfoArray = [NSMutableArray array];
    
    [self requestCampus];
}


#pragma mark - WMPageControllerDelegate, WMPageControllerDataSource
-(NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu{
    return self.subPageVCArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    return self.subPageVCArray[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return self.subPageTitleArray[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(15, 0, (ScreenWidth - kRootModularWidth)/2.0 - 30 , 44);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
   
    NSNumber *currIndex = info[@"index"];
    if (self.preIndex != currIndex.integerValue) {
        [(MIClassDetailViewController *)viewController resetSelectIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(campusManagerViewControllerPopEditClassState)]) {
            [self.delegate campusManagerViewControllerPopEditClassState];
        }
    }
    self.preIndex = currIndex.integerValue;
}

#pragma mark - MIClassDetailViewControllerDelegate 
- (void)classDetailViewControllerClickedIndex:(NSInteger)index clazz:(Clazz *)clazz{
    
    if (index == -1) {
        // 退出编辑班级页面
        if (self.delegate && [self.delegate respondsToSelector:@selector(campusManagerViewControllerPopEditClassState)]) {
            [self.delegate campusManagerViewControllerPopEditClassState];
        }
    } else {
      
        if (self.delegate && [self.delegate respondsToSelector:@selector(campusManagerViewControllerEditClazz:)]) {
            [self.delegate campusManagerViewControllerEditClazz:clazz];
        }
    }
}

- (void)createAction{
   
    [self resetSelectIndex];
    if (self.delegate && [self.delegate respondsToSelector:@selector(campusManagerViewControllerEditClazz:)]) {
        [self.delegate campusManagerViewControllerEditClazz:nil];
    }
}

- (void)updateClassInfo{// 更新对应校区
    
    [(MIClassDetailViewController *)self.pageController.currentViewController updateClassInfo];
}

- (void)resetSelectIndex{
    
    [(MIClassDetailViewController *)self.pageController.currentViewController resetSelectIndex];
}

#pragma mark -  获取校区列表
- (void)requestCampus{
  
    WeakifySelf;
    [ManagerServce requestCampusCallback:^(Result *result, NSError *error) {
   
        NSDictionary *dict = (NSDictionary *)result.userInfo;
        NSArray *campusArray = dict[@"list"];
        [weakSelf.campusInfoArray removeAllObjects];
        [weakSelf.campusInfoArray addObjectsFromArray:campusArray];
        NSMutableArray *tempCampus = [NSMutableArray array];
        for (CampusInfo *campus in campusArray) {
            [tempCampus addObject:campus.campusName];
        }
        weakSelf.subPageTitleArray = tempCampus;
        [weakSelf addSubPageViewController];
    }];
}

- (void)addSubPageViewController{
    
    [self.subPageVCArray removeAllObjects];
    for (int i = 0; i < self.subPageTitleArray.count; i++) {
        
        MIClassDetailViewController *classVC = [[MIClassDetailViewController alloc] init];
        classVC.delegate = self;
        classVC.campusInfo = self.campusInfoArray[i];
        [self.subPageVCArray addObject:classVC];
    }
    self.pageController = [[WMPageController alloc] initWithViewControllerClasses:self.subPageVCArray andTheirTitles:self.subPageTitleArray];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.menuViewStyle = WMMenuViewStyleLine;
    self.pageController.titleSizeNormal = 16.0;
    self.pageController.titleSizeSelected = 16.0;
    
    self.pageController.titleFontName = @"Helvetica-Bold";
    self.pageController.progressWidth = 25.0;
    self.pageController.progressHeight = 4.0;
    self.pageController.progressViewCornerRadius = 2.0;
    self.pageController.menuItemWidth = 80;
    self.pageController.itemMargin = 10;
    self.pageController.titleColorSelected = [UIColor mainColor];
    self.pageController.titleColorNormal = [UIColor detailColor];
    self.preIndex = self.pageController.selectIndex;
    
    self.pageController.view.frame = CGRectMake(0, 20, (ScreenWidth - kRootModularWidth)/2.0, ScreenHeight);
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];
    
    self.pageController.menuView.layoutMode = WMMenuViewLayoutModeCenter;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [btn setTitle:@"新建" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 45, 44);
    [self.pageController.menuView setRightView:btn];
    
    if (!self.rightLineView) {
        
        self.rightLineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - kRootModularWidth)/2.0 - 1.0, 0, 0.5, ScreenHeight)];
        self.rightLineView.backgroundColor = [UIColor separatorLineColor];
    }
    [self.view addSubview:self.rightLineView];
}
@end
