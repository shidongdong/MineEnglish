//
//  ImageMessageTableViewCell.m
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ImageMessageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

CGFloat const ImageMessageTableViewCellHeight = 152.f;

NSString * const LeftImageMessageTableViewCellId = @"LeftImageMessageTableViewCellId";
NSString * const RightImageMessageTableViewCellId = @"RightImageMessageTableViewCellId";

@interface ImageMessageTableViewCell()


@property (weak, nonatomic) IBOutlet UIView *messageContainerView;

@end

@implementation ImageMessageTableViewCell

- (IBAction)previewButtonPressed:(id)sender {
    if (self.imagePreviewCallback != nil) {
        self.imagePreviewCallback();
    }
}

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message {
    [super setupWithUser:user message:message];
    
    AVIMImageMessage *imageMessage = (AVIMImageMessage *)message;
    NSString *imageUrl = imageMessage.file.url;

    [self.messageImageView sd_setImageWithURL:[imageUrl imageURLWithWidth:218.f] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize  displayImageSize;
        
        if (!image)
        {
            return;
        }
        
        CGFloat rate = image.size.width / image.size.height;
        CGFloat orginRate = 218.0 / 140.0;
        
        if (rate >= orginRate) {
            displayImageSize = CGSizeMake(218, 218 * (image.size.height /  image.size.width));
        }
        else
        {
            displayImageSize = CGSizeMake(140 * (image.size.width /  image.size.height), 140 );
        }
        
        
        if (message.ioType == AVIMMessageIOTypeIn)
        {
            self.messageImageView.frame= CGRectMake(0, 0, displayImageSize.width, displayImageSize.height);
        }
        else
        {
            self.messageImageView.frame= CGRectMake(218 - displayImageSize.width, 0, displayImageSize.width, displayImageSize.height);
        }
        
        
        
        
//        NSString *backgroundImageName = message.ioType==AVIMMessageIOTypeIn?@"对话框_白色":@"对话框_蓝色";
//        UIImage *maskImage = [[UIImage imageNamed:backgroundImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20) resizingMode:UIImageResizingModeStretch];
//        [self.messageImageView fitShapeWithMaskImage:maskImage
//                                         topCapInset:30
//                                        leftCapInset:20
//                                                size:displayImageSize];
        
    }];
    

    
   
}

- (UIImageView *)messageImageView
{
    if (!_messageImageView)
    {
        _messageImageView = [[UIImageView alloc] init];
        _messageImageView.layer.cornerRadius = 10;
        _messageImageView.clipsToBounds = YES;
        _messageImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.messageContainerView addSubview:_messageImageView];
    }
    [self.messageContainerView sendSubviewToBack:_messageImageView];
    return _messageImageView;
}

@end

