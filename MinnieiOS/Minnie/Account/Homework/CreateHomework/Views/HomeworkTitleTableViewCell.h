//
//  HomeworkTitleTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeworkTitleTableViewCellId;

typedef void(^CellHeightDidChangeCallback)(NSString *text, BOOL heightChanged);

@interface HomeworkTitleTableViewCell : UITableViewCell

@property (nonatomic, copy) CellHeightDidChangeCallback callback;

- (void)setupWithText:(NSString *)text;

+ (CGFloat)cellHeightWithText:(NSString *)text;

- (void)ajustTextView;

@end
