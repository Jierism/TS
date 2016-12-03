//
//  TSCondition.m
//  天时
//
//  Created by  Jierism on 16/9/18.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "TSCondition.h"

@implementation TSCondition

// JSON到模型属性的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cityName": @"basic.city",
             @"nowCond": @"now.cond.txt",
             @"nowTmp": @"now.tmp",
             @"winddir": @"now.wind.dir",
             @"windsc": @"now.wind.sc",
             @"date": @"basic.update.loc",
             @"maxTmp": @"daily_forecast.tmp.max",
             @"minTmp": @"daily_forecast.tmp.min",
             @"weatherqlty": @"aqi.city.qlty"
             };
}





@end
