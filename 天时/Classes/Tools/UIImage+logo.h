//
//  UIImage+logo.h
//  天时
//
//  Created by  Jierism on 2016/11/1.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface UIImage (logo)

// 给图片加水印
+ (instancetype)imageWithImage:(UIImage *)image andViewController:(ViewController *)controller;

// 根据天气名字设置天气图片
+ (instancetype)stringWithWeather:(NSString *)weatherName;
// 根据建议名字设置图片
+ (instancetype)stringWithSuggestion:(NSString *)suggestionName;
@end
