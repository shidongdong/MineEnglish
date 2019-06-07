//
//  MIAddWordTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/6.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^MIAddWordTableViewCellCallback)(BOOL isAdd, NSArray *dataArray);
extern NSString * _Nullable const MIAddWordTableViewCellId;


@interface MIAddWordTableViewCell : UITableViewCell

@property (nonatomic,copy) MIAddWordTableViewCellCallback callback;

//Clazz ,User,NSString
+ (CGFloat)heightWithTags:(NSArray*)tags;

- (void)setupAwordWithDataArray:(NSArray <WordInfo *> *)dataArray;

- (void)setupParticipateWithClazzArray:(NSArray <Clazz *> *)clazzArray
                          studentArray:(NSArray <User *> *)studentArray;
@end

NS_ASSUME_NONNULL_END
