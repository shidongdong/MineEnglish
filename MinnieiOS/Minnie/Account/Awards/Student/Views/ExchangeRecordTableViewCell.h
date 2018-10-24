//
//  ExchangeRecordTableViewCell.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeRecord.h"

extern NSString * const ExchangeRecordTableViewCellId;
extern CGFloat const ExchangeRecordTableViewCellHeight;

@interface ExchangeRecordTableViewCell : UITableViewCell

- (void)setupWithExchangeRecord:(ExchangeRecord *)record;

@end
