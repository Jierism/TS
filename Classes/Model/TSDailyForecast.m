//
//  TSDailyForecast.m
//  天时
//
//  Created by  Jierism on 16/9/21.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "TSDailyForecast.h"

@implementation TSDailyForecast

// JSON到模型属性的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cond": @"cond.txt_d",
             @"maxTmp": @"tmp.max",
             @"minTmp": @"tmp.min",
             };
}

@end
