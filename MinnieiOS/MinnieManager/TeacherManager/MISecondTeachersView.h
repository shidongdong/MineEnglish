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


- (void)updateTeacherListWithListType:(NSInteger)listType;

@end

NS_ASSUME_NONNULL_END
