//
//  UIAlertController+Alert.m
//  Minnie
//
//  Created by songzhen on 2019/6/19.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "UIAlertController+Alert.h"

@implementation UIAlertController (Alert)

// 解决横屏时使用UIAlertController导致错误
- (BOOL)shouldAutorotate{
    
    return YES;
}

@end
