//
//  ClassAndStudentSelectView.h
//  Minnie
//
//  Created by songzhen on 2019/6/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^CancelCallBack)(void);

typedef void(^ClassAndStudentSelectCallBack)(NSArray<Clazz *> *_Nullable classes,NSArray<User *> *_Nullable students);


NS_ASSUME_NONNULL_BEGIN

@interface ClassAndStudentSelectView : UIView

@property (nonatomic, copy) CancelCallBack cancelBack;

@property (nonatomic, copy) ClassAndStudentSelectCallBack selectBack;

- (void)showSelectView;

@end

NS_ASSUME_NONNULL_END
