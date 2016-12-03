//
//  TSCondition.h
//  天时
//
//  Created by  Jierism on 16/9/18.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLModel.h>

@interface TSCondition : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *cityName;       // 城市名字
@property (nonatomic,copy) NSString *nowCond;        // 当前天气状况
@property (nonatomic,copy) NSString *nowTmp;         // 当前温度
@property (nonatomic,copy) NSString *winddir;        // 风向
@property (nonatomic,copy) NSString *windsc;         // 风力
@property (nonatomic,copy) NSString *date;           // 日期
@property (nonatomic,copy) NSString *maxTmp;         // 最高温度
@property (nonatomic,copy) NSString *minTmp;         // 最低温度
@property (nonatomic,copy) NSString *weatherqlty;    // 空气质量


@end
