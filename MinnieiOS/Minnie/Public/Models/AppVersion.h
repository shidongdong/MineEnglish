//
//  AppVersion.h
//  MinnieStudent
//
//  Created by 栋栋 施 on 2018/9/14.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

//@interface AppVersionData : MTLModel<MTLJSONSerializing>
//
//@property(nonatomic,strong)NSString * appVersion;
//@property(nonatomic,strong)NSString * appName;
//@property(nonatomic,assign)NSInteger upgradeType;
//@property(nonatomic,strong)NSString * appUrl;
//
//@end

@interface AppVersion : MTLModel<MTLJSONSerializing>

//@property(nonatomic)AppVersionData * data;
@property(nonatomic,strong)NSString * appVersion;
@property(nonatomic,strong)NSString * appName;
@property(nonatomic,assign)NSInteger upgradeType;
@property(nonatomic,strong)NSString * appUrl;
@property(nonatomic,strong)NSString * upgradeDes;
@end
