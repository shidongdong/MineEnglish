//
//  MITitleTypeTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/30.
//  Copyright © 2019 minnieedu. All rights reserved.
//  标题类型

#import "HomeworkItem.h"
#import <UIKit/UIKit.h>
#import "HomeworkAnswerItem.h"

typedef void(^ItemActionCallback)(NSArray * _Nullable items);

typedef void(^AnswerItemActionCallback)(NSArray *_Nullable anwserItems);

extern CGFloat const MITitleTypeTableViewCellHeight;

extern NSString * _Nullable const MITitleTypeTableViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MITitleTypeTableViewCell : UITableViewCell


@property (nonatomic, copy) ItemActionCallback addItemCallback;

@property (nonatomic, copy) AnswerItemActionCallback addAnswerItemCallback;

@property (nonatomic, copy) NSString * title;

- (void)setupWithItems:(NSArray<HomeworkItem *>*)items vc:(UIViewController *)vc;

- (void)setupWithAnswerItems:(NSArray<HomeworkAnswerItem *>*)answerItems vc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
