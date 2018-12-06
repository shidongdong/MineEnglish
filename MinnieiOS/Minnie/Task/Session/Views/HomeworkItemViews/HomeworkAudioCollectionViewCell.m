//
//  HomeworkAudioCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkAudioCollectionViewCell.h"

NSString * const HomeworkAudioCollectionViewCellId = @"HomeworkAudioCollectionViewCellId";

@interface HomeworkAudioCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *homeworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *audioDurationLabel;
@property (nonatomic, weak) IBOutlet UILabel *homeworkLabel;

@end

@implementation HomeworkAudioCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.homeworkImageView.layer.cornerRadius = 12.f;
    self.homeworkImageView.layer.masksToBounds = YES;
}

- (void)setupWithHomeworkItem:(HomeworkItem *)item name:(NSString *)name {
//    self.audioDurationLabel.text = [NSString stringWithFormat:@"%.fs", item.audioDuration];
    self.homeworkLabel.text = name;
}

+ (CGSize)cellSize {
    return CGSizeMake(90, 110);
}

@end
