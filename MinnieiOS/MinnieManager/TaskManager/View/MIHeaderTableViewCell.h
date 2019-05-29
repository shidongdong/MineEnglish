//
//  HeaderTableViewCell.h
//  Manager
//
//  Created by songzhen on 2019/5/27.
//  Copyright © 2019 songzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIFirLevelFolderModel.h"

@protocol HeaderViewDelegate <NSObject>

@optional

- (void)headerViewDidCellClicked:(NSInteger)index;

- (void)headerViewAddClicked:(NSInteger)index;

@end


NS_ASSUME_NONNULL_BEGIN

@interface MIHeaderTableViewCell : UITableViewCell

@property (nonatomic , assign) NSInteger section;

@property (nonatomic , strong) MIFirLevelFolderModel *typeModel;

@property (nonatomic , assign) id<HeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
