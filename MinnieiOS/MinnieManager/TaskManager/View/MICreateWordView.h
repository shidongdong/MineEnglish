//
//  MICreateWordView.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/6.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordInfo.h"

typedef void(^CreateWordViewCallBack) (WordInfo * _Nullable word);

NS_ASSUME_NONNULL_BEGIN

@interface MICreateWordView : UIView

@property (nonatomic,copy) CreateWordViewCallBack callback;

@end

NS_ASSUME_NONNULL_END
