//
//  HomeworkSessionTableViewCell.h
//  X5
//
//  Created by yebw on 2017/8/30.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkSession.h"

extern NSString * const UnfinishedHomeworkSessionTableViewCellId;
extern NSString * const FinishedHomeworkSessionTableViewCellId;
extern NSString * const UnfinishedStudentHomeworkSessionTableViewCellId;
@interface HomeworkSessionTableViewCell : UITableViewCell

- (void)setupWithHomeworkSession:(HomeworkSession *)homeworkSession;

+ (CGFloat)cellHeightWithHomeworkSession:(HomeworkSession *)homeworkSession
                                finished:(BOOL)finished;

- (void)setupSelectState:(BOOL)select;

@end

