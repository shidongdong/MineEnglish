//
//  HomeworkVideoTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkVideoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const HomeworkVideoTableViewCellId = @"HomeworkVideoTableViewCellId";
CGFloat const HomeworkVideoTableViewCellHeight = 112.f;

@interface HomeworkVideoTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *videoCoverImageView;
@property (nonatomic, copy) NSString *videoUrl;

@end

@implementation HomeworkVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.videoCoverImageView.layer.cornerRadius = 12;
    self.videoCoverImageView.layer.masksToBounds = YES;
}

- (void)setupWithVideoUrl:(NSString *)videoUrl
                 coverUrl:(NSString *)coverUrl {
    self.videoUrl = videoUrl;

    [self.videoCoverImageView sd_setImageWithURL:[videoUrl videoCoverUrlWithWidth:182 height:100]];
}



- (IBAction)playButtonPressed:(id)sender {
    if (self.playCallback != nil) {
        self.playCallback(self.videoUrl);
    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    if (self.deleteCallback != nil) {
        self.deleteCallback();
    }
}

@end

