//
//  HomeworkVideoCollectionViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"

extern NSString * const HomeworkVideoCollectionViewCellId;

@interface HomeworkVideoCollectionViewCell : UICollectionViewCell

- (void)setupWithHomeworkItem:(HomeworkItem *)item name:(NSString *)name;

+ (CGSize)cellSize;

@end
