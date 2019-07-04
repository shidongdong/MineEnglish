//
//  MITagsViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/5.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^TagsVCCancelCallBack)(void);

@interface MITagsViewController : UIViewController

@property (nonatomic, assign)TagsType type;

@property (nonatomic, copy)TagsVCCancelCallBack tagsCallBack;

@property (nonatomic, assign) BOOL teacherSider;

@end

NS_ASSUME_NONNULL_END
