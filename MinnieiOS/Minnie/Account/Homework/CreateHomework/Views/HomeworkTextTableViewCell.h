//
//  HomeworkTextTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeworkTextTableViewCellId;

typedef void(^CellHeightDidChangeCallback)(NSString *text, BOOL heightChanged);

@interface HomeworkTextTableViewCell : UITableViewCell

@property (nonatomic, copy) CellHeightDidChangeCallback callback;

- (void)setupWithText:(NSString *)text;

+ (CGFloat)cellHeightWithText:(NSString *)text;

- (void)ajustTextView;

@end
