//
//  MISecondTeachersView.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MISecondTeachersViewDelegate <NSObject>

- (void)secondTeaManViewDidClicledWithTeacher:(Teacher *)teacher listType:(NSInteger)type;

@end

@interface MISecondTeachersView : UIView

@property (nonatomic,weak) id<MISecondTeachersViewDelegate> delegate;

// listType:0 实时任务 1教师管理
// reset:是否需要重置当前选中 编辑教师权限，无需重置当前选中教师
- (void)updateTeacherListWithListType:(NSInteger)listType resetIndex:(BOOL)reset;


@end

NS_ASSUME_NONNULL_END
