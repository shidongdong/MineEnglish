//
//  AudioMessageTableViewCell.h
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "MessageTableViewCell.h"

typedef void(^AudioMessageTableViewCellPlayCallback)(void);

extern CGFloat const AudioMessageTableViewCellHeight;

extern NSString * const LeftAudioMessageTableViewCellId;
extern NSString * const RightAudioMessageTableViewCellId;

@interface AudioMessageTableViewCell : MessageTableViewCell

@property (nonatomic, copy) AudioMessageTableViewCellPlayCallback videoPlayCallback;

@end
