//
//  MITaskEmptyView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionCallBack) (BOOL isAddFolder);

NS_ASSUME_NONNULL_BEGIN

@interface MITaskEmptyView : UIView

@property (nonatomic, copy) ActionCallBack callBack;

@property (nonatomic, assign) BOOL isAddFolder;

@end

NS_ASSUME_NONNULL_END
