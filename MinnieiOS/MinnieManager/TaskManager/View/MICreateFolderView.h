//
//  MICreateFolderView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureCallBack) (NSString * _Nullable name);
typedef void(^CancelCallBack) (void);

NS_ASSUME_NONNULL_BEGIN

@interface MICreateFolderView : UIView

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) SureCallBack sureCallBack;

@property (nonatomic, copy) CancelCallBack cancelCallBack;



@end

NS_ASSUME_NONNULL_END
