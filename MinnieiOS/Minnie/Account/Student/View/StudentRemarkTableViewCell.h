//
//  StudentRemarkTableViewCell.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartCountCallback)(void);

extern NSString * _Nullable const StudentRemarkCellId;

NS_ASSUME_NONNULL_BEGIN

@interface StudentRemarkTableViewCell : UITableViewCell

@property (nonatomic, copy) StartCountCallback callback;

- (void)setCellTitle:(NSString *)title withContent:(NSString *)content;

+ (CGFloat)cellHeightWithTitle:(NSString *)title withContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
