//
//  ImageMessageTableViewCell.h
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "MaskImageView.h"

typedef void(^ImageMessageTableViewCellPreviewCallback)(void);

extern CGFloat const ImageMessageTableViewCellHeight;

extern NSString * const LeftImageMessageTableViewCellId;
extern NSString * const RightImageMessageTableViewCellId;

@interface ImageMessageTableViewCell : MessageTableViewCell

@property (nonatomic, copy) ImageMessageTableViewCellPreviewCallback imagePreviewCallback;
@property(nonatomic,strong)UIImageView * messageImageView;
//@property (nonatomic, weak) IBOutlet MaskImageView *messageImageView;

@end
