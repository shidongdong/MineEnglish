//
//  MessageTableViewCell.h
// X5
//
//  Created by yebw on 2017/8/25.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

typedef void(^MessageTableViewCellResendCallback)(void); // 重发回调

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, weak) IBOutlet UIButton *retryButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *sendingIndicatorView;

@property (nonatomic, copy) MessageTableViewCellResendCallback resendCallback;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) AVIMTypedMessage *message;

+ (CGFloat)heightOfMessage:(AVIMTypedMessage *)message;

- (void)setupWithUser:(User *)user message:(AVIMTypedMessage *)message;

- (IBAction)resendButtonPressed:(id)sender;

@end

