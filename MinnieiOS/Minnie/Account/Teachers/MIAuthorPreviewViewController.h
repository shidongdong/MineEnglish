//
//  MIAuthorPreviewViewController.h
//  Minnie
//
//  Created by songzhen on 2019/8/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITeacherAuthorTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EidtPreviewAuthorCallBack)(NSArray *authorArray);

@interface MIAuthorPreviewViewController : UIViewController

@property (nonatomic, assign) MIAuthorManagerType authorManagerType;

@property (nonatomic, copy) EidtPreviewAuthorCallBack editCallBack;

@property (nonatomic, strong) NSArray *authorArray;

@end

NS_ASSUME_NONNULL_END
