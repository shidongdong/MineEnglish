//
//  MIExpandSelectTypeTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//  时限选择类型

#import <UIKit/UIKit.h>

extern NSString * _Nullable const MIExpandSelectTypeTableViewCellId;

extern CGFloat const MIExpandSelectTypeTableViewCellHeight;

typedef void(^ExpandSelectCallback)(void);

typedef void(^LeftExpandSelectCallback)(void);

typedef void(^RightExpandSelectCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MIExpandSelectTypeTableViewCell : UITableViewCell

@property (nonatomic, copy)ExpandSelectCallback expandCallback;


@property (nonatomic, copy)LeftExpandSelectCallback leftExpandCallback;

@property (nonatomic, copy)RightExpandSelectCallback rightExpandCallback;

- (void)setupWithLeftText:(NSString *_Nullable)leftText
                rightText:(NSString *_Nullable)rightText
           createType:(MIHomeworkCreateContentType)createType;

@end

NS_ASSUME_NONNULL_END
