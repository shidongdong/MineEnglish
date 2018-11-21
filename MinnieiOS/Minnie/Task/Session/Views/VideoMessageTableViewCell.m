//
//  VideoMessageTableViewCell.m
//  X5
//
//  Created by yebw on 2017/10/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "VideoMessageTableViewCell.h"
#import "MaskImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

CGFloat const VideoMessageTableViewCellHeight = 152.f;

NSString * const LeftVideoMessageTableViewCellId = @"LeftVideoMessageTableViewCellId";
NSString * const RightVideoMessageTableViewCellId = @"RightVideoMessageTableViewCellId";

@interface VideoMessageTableViewCell()

@property (nonatomic, weak) IBOutlet MaskImageView *coverImageView;

@end

@implementation VideoMessageTableViewCell

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message {
    [super setupWithUser:user message:message];
    
    if ([message isKindOfClass:[AVIMVideoMessage class]])
    {
        AVIMVideoMessage * videoMsg = (AVIMVideoMessage *)message;
        NSLog(@"%f",videoMsg.duration);
        self.timeLabel.text = [NSString stringWithFormat:@"%f",videoMsg.duration];
    }
    
    [self.coverImageView sd_setImageWithURL:[message.file.url videoCoverUrlWithWidth:218.f height:140.f]];

    NSString *backgroundImageName = message.ioType==AVIMMessageIOTypeIn?@"对话框_白色":@"对话框_蓝色";
    UIImage *maskImage = [[UIImage imageNamed:backgroundImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20) resizingMode:UIImageResizingModeStretch];
    [self.coverImageView fitShapeWithMaskImage:maskImage
                                     topCapInset:30
                                    leftCapInset:20
                                            size:CGSizeMake(218, 140)];
}

- (IBAction)playButtonPressed:(id)sender {
    if (self.videoPlayCallback != nil) {
        self.videoPlayCallback();
    }
}

@end
