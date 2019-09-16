//
//  MITeacherOnlineTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/15.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MITeacherOnlineTableViewCellId;

extern CGFloat const MITeacherOnlineTableViewCellHeight;

@interface MITeacherOnlineTableViewCell : UITableViewCell

- (void)setupTimeWithTeacher:(TeacherDetail *)teacher;

@end

NS_ASSUME_NONNULL_END
