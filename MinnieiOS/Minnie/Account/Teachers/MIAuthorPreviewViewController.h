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

@interface MIAuthorPreviewViewController : UIViewController

@property (nonatomic, assign) MIAuthorManagerType authorManagerType;

@property (nonatomic, strong) NSArray<AuthorPreview> *authorArray; 

@end

NS_ASSUME_NONNULL_END
