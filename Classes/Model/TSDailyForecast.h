//
//  TSDailyForecast.h
//  天时
//
//  Created by  Jierism on 16/9/21.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TSDailyForecast : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *date;           // 日期
@property (nonatomic,copy) NSString *maxTmp;         // 最高温度
@property (nonatomic,copy) NSString *minTmp;         // 最低温度
@property (nonatomic,copy) NSString *cond;           // 天气情况

@end
