//
//  HomeworkTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkTableViewCell.h"
#import "UIColor+HEX.h"
#import "HomeworkImageCollectionViewCell.h"
#import "HomeworkVideoCollectionViewCell.h"
#import "HomeworkAudioCollectionViewCell.h"

NSString * const HomeworkTableViewCellId = @"HomeworkTableViewCellId";

@interface HomeworkTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *selecteButton;

@property (nonatomic, weak) IBOutlet UIView *editModeView;

@property (nonatomic, weak) IBOutlet UILabel *homeworkTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UILabel *homeworkTextLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *homeworksCollectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *homeworksCollectionViewHeightConstraint;

@property (nonatomic, assign) BOOL choice;

@property (nonatomic, strong) Homework *homework;

@end

@implementation HomeworkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
    
    self.homeworkTextLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 36 - 44;
    
    [self registerCellNibs];

    [self setupCollectionViewLayout];
}

- (void)registerCellNibs {
    [self.homeworksCollectionView registerNib:[UINib nibWithNibName:@"HomeworkImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeworkImageCollectionViewCellId];
    [self.homeworksCollectionView registerNib:[UINib nibWithNibName:@"HomeworkVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeworkVideoCollectionViewCellId];
    [self.homeworksCollectionView registerNib:[UINib nibWithNibName:@"HomeworkAudioCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeworkAudioCollectionViewCellId];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setupCollectionViewLayout];
}


- (void)setupCollectionViewLayout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(90, 110);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 12;
    
    self.homeworksCollectionView.collectionViewLayout = layout;
}

- (void)setupWithHomework:(Homework *)homework {
    self.homework = homework;
    
    self.homeworkTitleLabel.text = self.homework.title?:@"[无标题]";
    
    NSString *text = nil;
    for (HomeworkItem *item in self.homework.items) {
        if ([item.type isEqualToString:HomeworkItemTypeText]) {
            text = item.text;
            break;
        }
    }
    
    if (self.homework.items.count == 1) {
        self.homeworksCollectionViewHeightConstraint.constant = 0.f;
    } else {
        self.homeworksCollectionViewHeightConstraint.constant = 110.f;
    }

    self.homeworkTextLabel.text = text;
    self.dateLabel.text = [Utils formatedDateString:self.homework.createTime];
    
    [self.homeworksCollectionView reloadData];
}

- (void)updateWithEditMode:(BOOL)editMode selected:(BOOL)selected {
    if (editMode) {
        self.sendButton.hidden = YES;
        self.editModeView.hidden = NO;
    } else {
        self.sendButton.hidden = NO;
        self.editModeView.hidden = YES;
    }

    self.choice = selected;
    
    if (selected) {
        [self.selecteButton setImage:[UIImage imageNamed:@"icon_mission_choice"] forState:UIControlStateNormal];
    } else {
        [self.selecteButton setImage:[UIImage imageNamed:@"icon_mission_choice_disabled"] forState:UIControlStateNormal];
    }
}

+ (CGFloat)cellHeightWithHomework:(Homework *)homework {
    if (homework.cellHeight > 0) {
        return homework.cellHeight;
    }
    
    static HomeworkTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkTableViewCell" owner:nil options:nil] lastObject];
    });
    
    [cell setupWithHomework:homework];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    homework.cellHeight = size.height;
    
    return homework.cellHeight;
}

#pragma mark - IBActions

- (IBAction)sendButtonPressed:(id)sender {
    if (self.sendCallback != nil) {
        self.sendCallback();
    }
}

- (IBAction)selectButtonPressed:(id)sender {
    self.choice = !self.choice;

    if (self.choice) {
        [self.selecteButton setImage:[UIImage imageNamed:@"icon_mission_choice"] forState:UIControlStateNormal];
    } else {
        [self.selecteButton setImage:[UIImage imageNamed:@"icon_mission_choice_disabled"] forState:UIControlStateNormal];
    }
    
    if (self.selectCallback != nil) {
        self.selectCallback();
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = 0;
    
    for (HomeworkItem *item in self.homework.items) {
        if (![item.type isEqualToString:HomeworkItemTypeText]) {
            number++;
        }
    }
    
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    HomeworkItem *item = self.homework.items[indexPath.row+1];
    if ([item.type isEqualToString:HomeworkItemTypeImage]) {
        HomeworkImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkImageCollectionViewCellId forIndexPath:indexPath];
        
        [imageCell setupWithHomeworkItem:item name:[NSString stringWithFormat:@"材料%zd", indexPath.row+1]];
        
        cell = imageCell;
    } else if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
        HomeworkVideoCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkVideoCollectionViewCellId forIndexPath:indexPath];
        
        [videoCell setupWithHomeworkItem:item name:[NSString stringWithFormat:@"材料%zd", indexPath.row+1]];
        
        cell = videoCell;
    } else if ([item.type isEqualToString:HomeworkItemTypeAudio]) {
        HomeworkAudioCollectionViewCell *audioCell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeworkAudioCollectionViewCellId forIndexPath:indexPath];
        
        [audioCell setupWithHomeworkItem:item name:[NSString stringWithFormat:@"材料%zd", indexPath.row+1]];
        
        cell = audioCell;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    

    HomeworkItem *item = self.homework.items[indexPath.row+1];
    if ([item.type isEqualToString:HomeworkItemTypeImage]) {
        HomeworkImageCollectionViewCell *cell = (HomeworkImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if (self.imageCallback != nil) {
            self.imageCallback(cell.homeworkImageView, item.imageUrl);
        }
    } else if ([item.type isEqualToString:HomeworkItemTypeVideo]) {
        if (self.videoCallback != nil) {
            self.videoCallback(item.videoUrl);
        }
    }
}

@end

