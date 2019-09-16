//
//  MISelectImageViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/8/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MISelectImageViewController : UIViewController

@property (nonatomic,copy) void(^imageCallBack)(NSString *_Nullable imageUrl);

- (void)updateData;

- (void)saveImages;

@end

NS_ASSUME_NONNULL_END
