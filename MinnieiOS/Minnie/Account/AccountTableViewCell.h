//
//  AccountTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2017/12/16.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MessageCallback)(void);
typedef void(^ExchangeCallback)(void);

extern NSString * const AccountTableViewCellId;
extern CGFloat const AccountTableViewCellHeight;

@interface AccountTableViewCell : UITableViewCell

@property (nonatomic, copy) MessageCallback messageCallback;
@property (nonatomic, copy) ExchangeCallback exchangeCallback;

- (void)setup;

- (void)updateWithUnreadMessageCount:(NSUInteger)count;
- (void)updateWithUnexchangedCount:(NSUInteger)count;

@end

