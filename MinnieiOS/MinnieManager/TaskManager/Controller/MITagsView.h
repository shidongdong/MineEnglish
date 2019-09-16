//
//  MITagsView.h
//  Minnie
//
//  Created by songzhen on 2019/7/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsViewController.h"

typedef void(^MITagsViewCancelCallBack)(void);
NS_ASSUME_NONNULL_BEGIN

@interface MITagsView : UIView

@property (nonatomic, assign)TagsType type;

@property (nonatomic, copy)MITagsViewCancelCallBack tagsCallBack;

@end

NS_ASSUME_NONNULL_END
