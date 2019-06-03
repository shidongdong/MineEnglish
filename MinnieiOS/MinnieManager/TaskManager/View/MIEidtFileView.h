//
//  MIEidtFileView.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/2.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteFileCallback)(void);

typedef void(^RenameFileCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MIEidtFileView : UIView

@property (nonatomic,copy) DeleteFileCallback deleteCallback;
@property (nonatomic,copy) RenameFileCallback renameCallBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;

@end

NS_ASSUME_NONNULL_END
