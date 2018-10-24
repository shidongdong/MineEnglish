//
//  StudentsTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/29.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "StudentsTableViewCell.h"
#import "StudentCollectionViewCell.h"
#import "CustomCollectionView.h"

NSString * const StudentsTableViewCellId = @"StudentsTableViewCellId";

@interface StudentsTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet CustomCollectionView *studentsCollectionView;

@property (nonatomic, copy) NSArray *students;

@end

@implementation StudentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerCellNibs];
}

- (void)setupWithStudents:(NSArray *)students {
    self.students = students;
    
    [self.studentsCollectionView reloadData];
}

+ (CGFloat)cellHeightWithStudents:(NSArray *)students {
    if (students.count == 0) {
        return 12.f;
    }
    
    static StudentsTableViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"StudentsTableViewCell" owner:nil options:nil] lastObject];
    });
    
    [tempCell setupWithStudents:students];
    
    [tempCell setNeedsUpdateConstraints];
    [tempCell updateConstraintsIfNeeded];
    
    [tempCell setNeedsLayout];
    [tempCell layoutIfNeeded];
    
    CGSize size = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return size.height;
}

#pragma mark - Private Methods

- (void)registerCellNibs {
    [self.studentsCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:StudentCollectionViewCellId];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.students.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StudentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StudentCollectionViewCellId forIndexPath:indexPath];
    
    User *user = self.students[indexPath.row];
    
    [cell setupWithUser:user];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [StudentCollectionViewCell size];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(12, 20, 12, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 24;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

@end

