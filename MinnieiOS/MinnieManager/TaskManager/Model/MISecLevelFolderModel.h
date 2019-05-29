//
//  MISecLevelFolderModel.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "Homework.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MISecLevelFolderModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray <Homework *>*taskArray;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
