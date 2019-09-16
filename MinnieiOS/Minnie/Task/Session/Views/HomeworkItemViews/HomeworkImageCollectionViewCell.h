//
//  HomeworkImageCollectionViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"

extern NSString * const HomeworkImageCollectionViewCellId;

@interface HomeworkImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *homeworkImageView;

- (void)setupWithHomeworkItem:(HomeworkItem *)item name:(NSString *)name;

- (void)setupWithStartTask;

+ (CGSize)cellSize;

@end
