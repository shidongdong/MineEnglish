//
//  HomeworkAudioCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkAudioCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
NSString * const HomeworkAudioCollectionViewCellId = @"HomeworkAudioCollectionViewCellId";

@interface HomeworkAudioCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *homeworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *audioDurationLabel;
@property (nonatomic, weak) IBOutlet UILabel *homeworkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigTalkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallTalkImageView;

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
    if (item.audioCoverUrl.length > 0)
    {
        self.audioDurationLabel.hidden = YES;
        self.bigTalkImageView.hidden = YES;
        self.smallTalkImageView.hidden = NO;
        
        [self.homeworkImageView sd_setImageWithURL:[item.audioCoverUrl imageURLWithWidth:90] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
    }
    else
    {
        self.audioDurationLabel.hidden = NO;
        self.bigTalkImageView.hidden = NO;
        self.smallTalkImageView.hidden = YES;
        [self.homeworkImageView sd_setImageWithURL:nil];
    }
    
}

+ (CGSize)cellSize {
    return CGSizeMake(90, 110);
}

@end
