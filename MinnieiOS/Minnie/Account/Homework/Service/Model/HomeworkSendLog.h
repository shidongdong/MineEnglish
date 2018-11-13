//
//  HomeworkSendLog.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HomeworkSendLog : MTLModel<MTLJSONSerializing>

@property(nonatomic, copy)NSString * teacherName;
@property(nonatomic, strong)NSArray <NSString *> *homeworkTitles;
@property(nonatomic, strong)NSArray <NSString *> *classNames;
@property(nonatomic, strong)NSArray <NSString *> *studentNames;
@property(nonatomic, copy)NSString * createTime;

@end
