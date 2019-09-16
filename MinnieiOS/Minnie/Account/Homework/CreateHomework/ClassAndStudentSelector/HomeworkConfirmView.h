//
//  HomeworkConfirmView.h
//  Minnie
//
//  Created by songzhen on 2019/6/27.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeworkConfirmViewCancelCallBack)(void);

typedef void(^HomeworkConfirmViewSuccessCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkConfirmView : UIView

@property (nonatomic,copy) HomeworkConfirmViewCancelCallBack cancelCallBack;
@property (nonatomic,copy) HomeworkConfirmViewCancelCallBack successCallBack;


- (void)setupConfirmViewHomeworks:(NSArray *)homeworks
                          classes:(NSArray *)classes
                         students:(NSArray *)students
                          teacher:(Teacher *)teacher;

@end

NS_ASSUME_NONNULL_END
