//
//  HomeworkSendHisTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/1.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkSendLog.h"
extern NSString * const HomeworkSendHisTableViewCellId;

@interface HomeworkSendHisTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;

+ (CGFloat)calculateCellHightForData:(HomeworkSendLog *)data;

- (void)setContentData:(HomeworkSendLog *)data;

@end
