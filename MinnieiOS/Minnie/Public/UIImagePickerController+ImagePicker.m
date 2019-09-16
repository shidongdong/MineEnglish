//
//  UIImagePickerController+ImagePicker.m
//  Minnie
//
//  Created by songzhen on 2019/6/13.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "UIImagePickerController+ImagePicker.h"

@implementation UIImagePickerController (ImagePicker)

#if MANAGERSIDE

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
}

#endif

@end
