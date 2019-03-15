//
//  HomeworkAnswersPickerViewController.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/9.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "BaseViewController.h"
@class HomeworkAnswerItem;

@protocol HomeworkAnswersPickerViewControllerDelegate <NSObject>

- (void)sendAnswer:(NSArray *)answers;

@end

@interface HomeworkAnswersPickerViewController : BaseViewController

@property (nonatomic,strong)NSArray <HomeworkAnswerItem *>* answerItems;
@property (nonatomic,assign)NSInteger columnNumber;
@property (nonatomic,assign)id<HomeworkAnswersPickerViewControllerDelegate>delegate;
@end

