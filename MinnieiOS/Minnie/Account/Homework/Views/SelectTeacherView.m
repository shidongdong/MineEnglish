//
//  SelectTeacherView.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "SelectTeacherView.h"
#import <Masonry/Masonry.h>
#import "UIColor+HEX.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Teacher.h"
#import "TeacherCollectionViewCell.h"
#import "SendTimePickerView.h"
#import "EqualSpaceFlowLayout.h"

@interface SelectTeacherView()<UICollectionViewDataSource, UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate>

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
// 内容
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *selectedTeacherNameLabel;

@property (nonatomic, strong) UICollectionView *teachersCollectionView;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) NSArray *teachers;
@property (nonatomic, strong) Teacher *selectedTeacher;

@property (nonatomic, copy) SelectTeacherViewSendCallback confirmCallback;

@end

@implementation SelectTeacherView

+ (instancetype)sharedInstance {
    static SelectTeacherView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectTeacherView class]) owner:nil options:nil] lastObject];
    });
    
    return instance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.confirmButton.enabled = NO;
    [self addContentView];
    self.confirmButton.backgroundColor = nil;
    self.confirmButton.layer.cornerRadius = 12.f;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x0098FE]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x0098FE alpha:0.8]] forState:UIControlStateHighlighted];
    
    self.cancelButton.layer.cornerRadius = 12.f;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = 0.5;
    self.cancelButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
}

- (void)addContentView{
    
    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    self.teachersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 50) collectionViewLayout:flowLayout];
    self.teachersCollectionView.backgroundColor = [UIColor whiteColor];
    self.teachersCollectionView.delegate = self;
    self.teachersCollectionView.dataSource = self;
    [self addSubview:self.teachersCollectionView];
    [self.teachersCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:TeacherCollectionViewCellId];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)showInSuperView:(UIView *)superView
               teachers:(NSArray *)teachers
               callback:(SelectTeacherViewSendCallback)callback {
    SelectTeacherView *view = [SelectTeacherView sharedInstance];
    if (view.superview != nil) {
        [view removeFromSuperview];
    }
    view.teachers = teachers;
    view.confirmCallback = callback;
    
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    [view showWithAnimation];
}

- (void)showWithAnimation {
    self.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .3f;
        scaleAnimation.values = @[@0, @1];
        scaleAnimation.keyTimes = @[@0, @.3];
        scaleAnimation.repeatCount = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        self.teachersCollectionView.alpha = 0.f;
        self.backgroundView.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1.f;
            self.teachersCollectionView.alpha = 1.f;
            
            
            CGFloat collectionHeight = [SelectTeacherView heightWithTags:self.teachers];
            CGFloat contentHeight = collectionHeight + 84 + 90;
            if (collectionHeight > ScreenHeight *0.4) {
                collectionHeight = ScreenHeight * 0.4;
                contentHeight = collectionHeight + 84 + 90;
            }
            [self.teachersCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(collectionHeight);
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.contentView.mas_top).offset(84);
            }];
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentHeight);
                make.left.right.bottom.equalTo(self.backgroundView);
            }];
        } completion:^(BOOL finished) {
        }];
    });
}
+ (CGFloat)heightWithTags:(NSArray <Teacher *> *)tags{
    
    if (tags.count == 0) {
        return 50.f;
    }
    CGFloat leftSpace = 10;
    CGFloat topSpace = 10;
    CGFloat rightSpace = 10;
    CGFloat minimumInteritemSpacing = 10;
    CGFloat minimumLineSpacing = 10;
    
    CGFloat xOffset = leftSpace;
    CGFloat yOffset = topSpace;
    CGFloat xNextOffset = leftSpace;
    
    CGFloat height = 0;
    for (NSInteger idx = 0; idx < tags.count; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        Teacher *teacher = tags[indexPath.row];
        CGSize itemSize = [TeacherCollectionViewCell cellSizeWithTeacher:teacher];
        
        xNextOffset+=(minimumInteritemSpacing + itemSize.width);
        if (xNextOffset >= [UIScreen mainScreen].bounds.size.width - 30 - rightSpace) {
            xOffset = leftSpace;
            xNextOffset = (leftSpace + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        height = yOffset + itemSize.height + 10;
    }
    return height;
}

+ (void)hideAnimated:(BOOL)animated {
   
    SelectTeacherView *studentView = [SelectTeacherView sharedInstance];
    dispatch_async(dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = .3f;
        scaleAnimation.values = @[@1, @0];
        scaleAnimation.keyTimes = @[@0, @.3];
        scaleAnimation.repeatCount = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [studentView.contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        studentView.backgroundView.alpha = 1.f;
        studentView.teachersCollectionView.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            studentView.backgroundView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [studentView removeFromSuperview];
        }];
    });
}

- (IBAction)cancelButtonPressed:(id)sender {
    [[self class] hideAnimated:YES];
}

- (IBAction)confirmButtonPressed:(id)sender {

    if (self.selectedTeacher.userId == 0) {
        [HUD showErrorWithMessage:@"请选择教师"];
        
        return;
    }
    
    if (self.confirmCallback != nil) {
        self.confirmCallback(self.selectedTeacher, nil);
    }
}

- (IBAction)datePickerButtonPressed:(id)sender {
    if (self.selectedTeacher.userId == 0) {
        [HUD showErrorWithMessage:@"请选择教师"];

        return;
    }
    [SendTimePickerView showInView:self.superview callback:^(NSDate *date) {
        if (self.confirmCallback != nil) {
            self.confirmCallback(self.selectedTeacher, date);
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.teachers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeacherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeacherCollectionViewCellId
                                                                                forIndexPath:indexPath];
    Teacher *teacher = self.teachers[indexPath.row];
    [cell setupWithTeacher:teacher];
    [cell setChoice:self.selectedTeacher.userId==teacher.userId];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    Teacher *teacher = self.teachers[indexPath.item];
    if (teacher.userId == self.selectedTeacher.userId) {
        return;
    }
    
    for (TeacherCollectionViewCell *visibleCell in [collectionView visibleCells]) {
        [visibleCell setChoice:NO];
    }
    
    TeacherCollectionViewCell *cell = (TeacherCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setChoice:YES];
    self.selectedTeacher = teacher;
    self.selectedTeacherNameLabel.text = teacher.nickname;
    self.confirmButton.enabled = self.selectedTeacher.userId>0;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Teacher *teacher = self.teachers[indexPath.row];
    CGSize itemSize = [TeacherCollectionViewCell cellSizeWithTeacher:teacher];
    // 标签长度大于屏幕
    if (itemSize.width > ScreenWidth -30) {
        
        itemSize.width = ScreenWidth - 30;
    }
    return itemSize;
}

- (Teacher *)selectedTeacher{
    
    if (!_selectedTeacher) {
        
        _selectedTeacher = [[Teacher alloc] init];
    }
    return _selectedTeacher;
}


@end

