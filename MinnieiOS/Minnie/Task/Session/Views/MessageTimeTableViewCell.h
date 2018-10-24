//
//  MessageTimeTableViewCell.h
//  X5
//
//  Created by yebw on 2017/10/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const MessageTimeTableViewCellHeight;
extern NSString * const MessageTimeTableViewCellId;

@interface MessageTimeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end
