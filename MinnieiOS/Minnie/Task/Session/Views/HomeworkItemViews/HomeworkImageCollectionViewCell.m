//
//  HomeworkImageCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const HomeworkImageCollectionViewCellId = @"HomeworkImageCollectionViewCellId";

@interface HomeworkImageCollectionViewCell()

@property (nonatomic, weak) IBOutlet UILabel *homeworkLabel;

@end

@implementation HomeworkImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.homeworkImageView.layer.cornerRadius = 12.f;
    self.homeworkImageView.layer.masksToBounds = YES;
}

- (void)setupWithHomeworkItem:(HomeworkItem *)item name:(NSString *)name {
    [self.homeworkImageView sd_setImageWithURL:[item.imageUrl imageURLWithWidth:90] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
    self.homeworkLabel.text = name;
}

+ (CGSize)cellSize {
    return CGSizeMake(90, 110);
}

@end
