//
//  AudioMessageTableViewCell.m
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "AudioMessageTableViewCell.h"
#import "AudioPlayer.h"

CGFloat const AudioMessageTableViewCellHeight = 56.f;

NSString * const LeftAudioMessageTableViewCellId = @"LeftAudioMessageTableViewCellId";
NSString * const RightAudioMessageTableViewCellId = @"RightAudioMessageTableViewCellId";

@interface AudioMessageTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *audioImageView;
@property (nonatomic, weak) IBOutlet UIImageView *audioBackgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewWidthConstraint;

@end

@implementation AudioMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayStateDidChange:)
                                                 name:kNotificationOfAudioPlayerStateDidChange
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)audioPlayStateDidChange:(NSNotification *)notification {
    NSString *currentPlayUrl = [[AudioPlayer sharedPlayer].currentURL absoluteString];
    if (![self.message.file.url isEqualToString:currentPlayUrl]) {
        return;
    }
    
    if ([AudioPlayer sharedPlayer].state == AudioPlayerStop) {
        self.audioImageView.image = [UIImage imageNamed:self.message.ioType==AVIMMessageIOTypeIn?@"chat_talk3":@"right_chat_talk3"];
    } else {
        UIImage *image0 = [UIImage imageNamed:self.message.ioType==AVIMMessageIOTypeIn?@"chat_talk1":@"right_chat_talk1"];
        UIImage *image1 = [UIImage imageNamed:self.message.ioType==AVIMMessageIOTypeIn?@"chat_talk2":@"right_chat_talk2"];
        UIImage *image2 = [UIImage imageNamed:self.message.ioType==AVIMMessageIOTypeIn?@"chat_talk3":@"right_chat_talk3"];
        
        self.audioImageView.image = [UIImage animatedImageWithImages:@[image0, image1, image2] duration:0.9];
    }
}

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message {
    [super setupWithUser:user message:message];
    
    if (![message isKindOfClass:[AVIMAudioMessage class]]) {
        return ;
    }

    CGFloat maxWidth = ScreenWidth - (12 + 44 + 8)*2;
    CGFloat minWidth = 60.f;
    
    NSInteger duration = [message.attributes[@"audioDuration"] integerValue];
    if (duration > 0) {
        self.durationLabel.text = [NSString stringWithFormat:@"%zd″", duration];
        
        CGFloat width = minWidth + (maxWidth - minWidth) * MIN(1, duration / 20.f);
        self.viewWidthConstraint.constant = width;
    } else {
        self.durationLabel.text = nil;
        self.viewWidthConstraint.constant = 60.f;
    }

    NSString *backgroundImageName = self.message.ioType==AVIMMessageIOTypeIn?@"对话框_白色":@"对话框_蓝色";
    UIImage *image = [UIImage imageNamed:backgroundImageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20) resizingMode:UIImageResizingModeStretch];
    self.audioBackgroundImageView.image = image;
}

- (IBAction)playButtonPressed:(id)sender {
    NSString *fileUrl = self.message.file.url;
    
    [[AudioPlayer sharedPlayer] playURL:[NSURL URLWithString:fileUrl]];
}

@end


