//
//  HomeAddTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/26.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkAddTableViewCell.h"
#import "UIColor+HEX.h"

NSString * const HomeworkAddTableViewCellId = @"HomeworkAddTableViewCellId";
CGFloat const HomeworkAddTableViewCellHeight = 78.f;

@interface HomeworkAddTableViewCell()

@property (nonatomic, weak) IBOutlet UIButton *addButton;

@end

@implementation HomeworkAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addButton.layer.cornerRadius = 12.f;
    self.addButton.layer.masksToBounds = NO;
    
    self.addButton.layer.borderWidth = 1.f;
    self.addButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
}

- (IBAction)addButtonPressed:(id)sender {
    if (self.addCallback != nil) {
        self.addCallback();
    }
}

@end
