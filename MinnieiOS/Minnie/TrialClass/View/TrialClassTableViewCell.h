//
//  TrialClassTableViewCell.h
//  MinnieStudent
//
//  Created by yebw on 2018/4/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clazz.h"

extern NSString * const TrialClassTableViewCellId;
extern CGFloat const TrialClassTableViewCellHeight;

typedef void(^TrialClassTableViewCellChoiceCallback)(void);

@interface TrialClassTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL choice;
@property (nonatomic, copy) TrialClassTableViewCellChoiceCallback callback;

- (void)setupWithClass:(Clazz *)clazz;

@end
