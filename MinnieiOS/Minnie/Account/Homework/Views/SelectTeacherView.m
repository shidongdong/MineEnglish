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

@interface SelectTeacherView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *selectedTeacherNameLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *teachersCollectionView;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

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
    
    [self.teachersCollectionView registerNib:[UINib nibWithNibName:@"TeacherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:TeacherCollectionViewCellId];

    self.confirmButton.backgroundColor = nil;
    self.confirmButton.layer.cornerRadius = 12.f;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x0098FE]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x0098FE alpha:0.8]] forState:UIControlStateHighlighted];
    
    self.cancelButton.layer.cornerRadius = 12.f;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = 0.5;
    self.cancelButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
    
    self.contentView.layer.cornerRadius = 12.f;
    self.contentView.layer.shadowOpacity = 0.15;// 阴影透明度
    self.contentView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.f].CGColor;
    self.contentView.layer.shadowRadius = 3;
    self.contentView.layer.shadowOffset = CGSizeMake(2, 4);
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
        
        self.backgroundView.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    });
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Teacher *teacher = self.teachers[indexPath.row];
    return [TeacherCollectionViewCell cellSizeWithTeacher:teacher];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 12, 16, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
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

    NSLog(@"collectionView   %@, %lu",[self.teachers[indexPath.item] class],indexPath.row);
    
    self.selectedTeacherNameLabel.text = teacher.nickname;
    self.confirmButton.enabled = self.selectedTeacher.userId>0;
}

- (Teacher *)selectedTeacher{
    
    if (!_selectedTeacher) {
        
        _selectedTeacher = [[Teacher alloc] init];
    }
    return _selectedTeacher;
}


@end

