//
//  ClassSelectorViewController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ClassSelectorViewControllerSelectCallback)(NSInteger);

@interface ClassSelectorViewController : BaseViewController

@property (nonatomic, copy) ClassSelectorViewControllerSelectCallback selectCallback;

@property (nonatomic, strong) NSMutableArray *selectedClasses;

- (void)unselectAll;

@end
