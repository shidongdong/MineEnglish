//
//  CorrectHomeworkAddCommentViewController.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseViewController.h"

@protocol CorrectHomeworkAddCommentViewControllerDelegate <NSObject>

- (void)addComment:(NSString *)info;

@end

@interface CorrectHomeworkAddCommentViewController : BaseViewController

@property (nonatomic, weak)id<CorrectHomeworkAddCommentViewControllerDelegate>delegate;

@end

