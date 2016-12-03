//
//  TSLifeSuggestion.m
//  天时
//
//  Created by  Jierism on 16/9/22.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "TSLifeSuggestion.h"




@implementation TSLifeSuggestion

// JSON到模型属性的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"level": @"text.brf",
             @"suggestionTxt": @"text.txt",
             @"sutitle": @"title",
             };
}

@end
