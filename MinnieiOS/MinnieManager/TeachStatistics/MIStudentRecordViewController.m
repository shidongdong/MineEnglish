//
//  MIStudentRecordViewController.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/11.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "WMPageController.h"
#import "MIStudentRecordViewController.h"
#import "StudentStarRecordViewController.h"

@interface MIStudentRecordViewController ()<
WMPageControllerDelegate,
WMPageControllerDataSource,
UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSMutableArray *subPageVCArray;

@property (nonatomic, strong) NSArray *subPageTitleArray;

@property (nonatomic, strong) WMPageController *pageController;

@end

@implementation MIStudentRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor emptyBgColor];
    
    self.subPageVCArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
      
        StudentStarRecordViewController * statRecordVC = [[StudentStarRecordViewController alloc] initWithNibName:NSStringFromClass([StudentStarRecordViewController class]) bundle:nil];
        statRecordVC.recordType = i;
        [self.subPageVCArray addObject:statRecordVC];
    }
    self.subPageTitleArray = @[@"星星获取", @"礼物兑换",@"任务得分",@"考试统计"];
    self.pageController = [[WMPageController alloc] initWithViewControllerClasses:self.subPageVCArray andTheirTitles:self.subPageTitleArray];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    self.pageController.menuViewStyle = WMMenuViewStyleLine;
    self.pageController.titleSizeNormal = 14.0;
    self.pageController.titleSizeSelected = 14.0;
    self.pageController.progressWidth = 25.0;
    self.pageController.progressHeight = 4.0;
    self.pageController.progressViewCornerRadius = 2.0;
    self.pageController.menuItemWidth = 80;
    self.pageController.titleColorSelected = [UIColor mainColor];
    self.pageController.titleColorNormal = [UIColor detailColor];
    self.pageController.progressViewIsNaughty = YES;
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNaviBarHeight, kColumnThreeWidth, ScreenHeight - kNaviBarHeight)];
    self.pageController.view.frame = CGRectMake(0, 0, kColumnThreeWidth, ScreenHeight - kNaviBarHeight);
    [self.view addSubview:_containerView];
    
    [_containerView addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];

}

-(void)updateStudentRecordWithStudentId:(NSInteger)studentId{
    
    [(StudentStarRecordViewController *)self.pageController.currentViewController updateStarRecordWithSutdentId:studentId];
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
    
    return CGRectMake(15, 0, kColumnThreeWidth - 30 , 35);
}

@end
