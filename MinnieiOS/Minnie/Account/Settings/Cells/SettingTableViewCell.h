//
//  SettingTableViewCell.h
//  X5
//
//  Created by yebw on 2017/8/28.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const SettingTableViewCellHeight;
extern NSString * const SettingTableViewCellId;

@interface SettingTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *itemLabel;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *actionLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

- (void)setupSelectedState:(BOOL)state;

@end
