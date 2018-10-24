//
//  HomeworkAudioTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkAudioTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const HomeworkAudioTableViewCellId = @"HomeworkAudioTableViewCellId";
CGFloat const HomeworkAudioTableViewCellHeight = 112.f;

@interface HomeworkAudioTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *audioCoverImageView;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, copy) NSString *AudioUrl;

@end

@implementation HomeworkAudioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.audioCoverImageView.layer.cornerRadius = 12;
    self.audioCoverImageView.layer.masksToBounds = YES;
}

- (void)setupWithAudioUrl:(NSString *)AudioUrl duration:(NSTimeInterval)duration {
    self.AudioUrl = AudioUrl;
    self.durationLabel.text = [NSString stringWithFormat:@"%.f秒", duration];
}

- (IBAction)playButtonPressed:(id)sender {
//    if (self.playCallback != nil) {
//        self.playCallback(self.AudioUrl);
//    }
}

- (IBAction)deleteButtonPressed:(id)sender {
    if (self.deleteCallback != nil) {
        self.deleteCallback();
    }
}

@end


