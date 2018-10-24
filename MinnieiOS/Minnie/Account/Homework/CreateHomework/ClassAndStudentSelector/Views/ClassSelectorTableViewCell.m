//
//  ClassSelectorTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "ClassSelectorTableViewCell.h"

NSString * const ClassSelectorTableViewCellId = @"ClassSelectorTableViewCellId";
CGFloat const ClassSelectorTableViewCellHeight = 50.f;

@interface ClassSelectorTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *choiceStateImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@end

@implementation ClassSelectorTableViewCell

- (void)setChoice:(BOOL)choice {
    _choice = choice;
    
    if (choice) {
        self.choiceStateImageView.image = [UIImage imageNamed:@"icon_mission_choice"];
    } else {
        self.choiceStateImageView.image = [UIImage imageNamed:@"icon_mission_choice_disabled"];
    }
}

- (void)setupWithClazz:(Clazz *)clazz {
    self.nameLabel.text = clazz.name;
    self.locationLabel.text = clazz.location;
}

@end

