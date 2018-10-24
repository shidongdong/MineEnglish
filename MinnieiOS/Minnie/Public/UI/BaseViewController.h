//
//  BaseViewController.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *customTitleLabel;

- (IBAction)backButtonPressed:(id)sender;

@end
