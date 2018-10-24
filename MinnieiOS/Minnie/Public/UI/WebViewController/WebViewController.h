//
//  WebViewController.h
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

+ (WebViewController *)openURL:(NSURL *)url inNavigationController:(UINavigationController *)navigationController;

@end
