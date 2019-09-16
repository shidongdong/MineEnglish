//
//  MILookImagesViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/8/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MILookImagesViewController : UIViewController


@property (copy, nonatomic) void (^uploadImagesCallBack)(void);


@property (nonatomic,copy) NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
