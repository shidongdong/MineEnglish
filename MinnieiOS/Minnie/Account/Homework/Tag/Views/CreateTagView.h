//
//  CreateTagView.h
//  X5Teacher
//
//  Created by yebw on 2018/1/23.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmCreateTagClickCallback)(NSString *tag);

@interface CreateTagView : UIView

+ (void)showInSuperView:(UIView *)superView
               callback:(ConfirmCreateTagClickCallback)callback;

+ (void)hideAnimated:(BOOL)animated;

@end


