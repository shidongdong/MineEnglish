//
//  MIFirLevelFolderModel.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/28.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "MISecLevelFolderModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIFirLevelFolderModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray <MISecLevelFolderModel *>*folderArray;

@property (nonatomic, assign) BOOL isOpen;

@end

NS_ASSUME_NONNULL_END
