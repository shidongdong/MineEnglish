//
//  ExchangeRequestTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeRecord.h"

typedef void(^ExchangeRequestTableViewCellExchangeCallback)(void);

extern NSString * const ExchangeRequestTableViewCellId;
extern CGFloat const ExchangeRequestTableViewCellHeight;

@interface ExchangeRequestTableViewCell : UITableViewCell

@property (nonatomic, copy) ExchangeRequestTableViewCellExchangeCallback exchangeCallback;

- (void)setupWithExchangeRequest:(ExchangeRecord *)record;

@end
