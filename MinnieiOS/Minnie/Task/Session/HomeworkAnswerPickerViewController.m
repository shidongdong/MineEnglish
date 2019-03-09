//
//  HomeworkAnswerPickerViewController.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/2/27.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "HomeworkAnswerPickerViewController.h"
#import "TZPhotoPickerController.h"
#import "TZPhotoPreviewController.h"

#import "TZAssetCell.h"
#import "TZImagePickerController.h"
#import "AnswerPickerCollectionViewCell.h"
@interface HomeworkAnswerPickerViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    NSMutableArray *_models;
    
    UIView *_bottomToolBar;
    UIButton *_previewButton;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIView *_divideLine;
    CGFloat _offsetItemCount;
}
@property CGRect previousPreheatRect;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) TZCollectionView *collectionView;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray * selectedModels;
@end

static CGSize AssetGridThumbnailSize;
static CGFloat itemMargin = 5;

@implementation HomeworkAnswerPickerViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"答案";
    [self initSubviews];
}

- (void)initSubviews {
    [self configCollectionView];
    self->_collectionView.hidden = YES;
    [self configBottomToolBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[TZCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
    _collectionView.contentSize = CGSizeMake(self.view.tz_width, ((self.models.count + self.columnNumber - 1) / self.columnNumber) * self.view.tz_width);
    if (_models.count == 0) {
        _noDataLabel = [UILabel new];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.text = @"没有答案";
        CGFloat rgb = 153 / 256.0;
        _noDataLabel.textColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _noDataLabel.font = [UIFont boldSystemFontOfSize:20];
        [_collectionView addSubview:_noDataLabel];
    }
    
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZAssetCell class] forCellWithReuseIdentifier:@"AnswerCellIdentify"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)configBottomToolBar {
    _bottomToolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 253 / 255.0;
    _bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    
    _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton setTitle:@"预览" forState:UIControlStateDisabled];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _previewButton.enabled = self.selectedModels.count;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitle:@"完成" forState:UIControlStateDisabled];
    [_doneButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateDisabled];
    _doneButton.enabled = NO;
    
    _numberImageView = [[UIImageView alloc] initWithImage:nil];
    _numberImageView.hidden = self.selectedModels.count <= 0;
    _numberImageView.clipsToBounds = YES;
    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",self.selectedModels.count];
    _numberLabel.hidden = self.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    _divideLine = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    _divideLine.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    
    [_bottomToolBar addSubview:_divideLine];
    [_bottomToolBar addSubview:_previewButton];
    [_bottomToolBar addSubview:_doneButton];
    [_bottomToolBar addSubview:_numberImageView];
    [_bottomToolBar addSubview:_numberLabel];
    [self.view addSubview:_bottomToolBar];
    
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat top = 0;
    CGFloat collectionViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.tz_height;
    CGFloat toolBarHeight = [TZCommonTools tz_isIPhoneX] ? 50 + (83 - 49) : 50;
    collectionViewHeight =  self.view.tz_height - toolBarHeight;
    _collectionView.frame = CGRectMake(0, top, self.view.tz_width, collectionViewHeight);
    _noDataLabel.frame = _collectionView.bounds;
    CGFloat itemWH = (self.view.tz_width - (self.columnNumber + 1) * itemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = itemMargin;
    _layout.minimumLineSpacing = itemMargin;
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetY = _offsetItemCount * (_layout.itemSize.height + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    CGFloat navigationHeight = naviBarHeight + [TZCommonTools tz_statusBarHeight];
    CGFloat toolBarTop = self.view.tz_height - toolBarHeight - navigationHeight;
    _bottomToolBar.frame = CGRectMake(0, toolBarTop, self.view.tz_width, toolBarHeight);
    
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.tz_width - _doneButton.tz_width - 12, 0, _doneButton.tz_width, 50);
    _numberImageView.frame = CGRectMake(_doneButton.tz_left - 24 - 5, 13, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    _divideLine.frame = CGRectMake(0, 0, self.view.tz_width, 1);

    [self.collectionView reloadData];
    
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.y / (_layout.itemSize.height + _layout.minimumLineSpacing);
}

#pragma mark - Click Event
- (void)navLeftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//预览
- (void)previewButtonClick {
    
}

//发送答案
- (void)doneButtonClick {
    
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    // the cell dipaly photo or video / 展示照片或视频的cell
    AnswerPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswerCellIdentify" forIndexPath:indexPath];
    NSString * imageURL  = self.models[indexPath.item];
    cell.imageURL = imageURL;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        // 1. cancel select / 取消选择
        if (isSelected) {
            
        } else {
            
        }
        [self refreshBottomToolBarStatus];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // preview phote or video / 预览照片或视频
//    NSInteger index = indexPath.item;
//    NSString * imageURL = _models[index];
//    TZPhotoPreviewController *photoPreviewVc = [[TZPhotoPreviewController alloc] init];
//    photoPreviewVc.currentIndex = index;
//    photoPreviewVc.photos = self.models;
//    [self pushPhotoPrevireViewController:photoPreviewVc];
    
}


- (void)refreshBottomToolBarStatus {
    
    _previewButton.enabled = self.selectedModels.count > 0;
    _doneButton.enabled = self.selectedModels.count > 0 ? YES : NO;
    
    _numberImageView.hidden = self.selectedModels.count <= 0;
    _numberLabel.hidden = self.selectedModels.count <= 0;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",self.selectedModels.count];
    
}

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

#pragma clang diagnostic pop

@end

