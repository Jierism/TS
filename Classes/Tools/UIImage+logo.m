//
//  UIImage+logo.m
//  天时
//
//  Created by  Jierism on 2016/11/1.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "UIImage+logo.h"


@implementation UIImage (logo)

// 在图片上加水印
+ (instancetype)imageWithImage:(UIImage *)image andViewController:(ViewController *)controller
{
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [image drawAtPoint:CGPointZero];
    
    // 设置文字的样式
    // **文字阴影
    NSShadow *shadow =[[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2;    // 模糊度
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(1, 3);
    
    NSDictionary *CityDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"KaiTi_GB2312" size: 40],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSShadowAttributeName : shadow
                               
                               };
    NSDictionary *dict = @{
                           NSFontAttributeName : [UIFont fontWithName:@"KaiTi_GB2312" size: 25],
                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSShadowAttributeName : shadow
                           };
    
    CGFloat cityX = image.size.width - image.size.width / 4;
    CGFloat cityY = image.size.height / 13;
    // 画上城市名
    [controller.cityName drawAtPoint:CGPointMake(cityX , cityY) withAttributes:CityDict];
    
    CGFloat imgX = cityX + 80;
    CGFloat imgY = cityY - 20;
    CGFloat imgW = 80;
    // 画上天气图片
    UIImage *condImg = [UIImage stringWithWeather:controller.jsonDic[@"now"][@"cond"][@"txt"]];
    [condImg drawInRect:CGRectMake(imgX, imgY, imgW , imgW)];
    
    CGFloat tempX = cityX + 40;
    CGFloat tempY = cityY + 60;
    
    // 画上温度计
    UIImage *shape = [UIImage imageNamed:@"Shape"];
    [shape drawInRect:CGRectMake(tempX-20, tempY, 14, 24)];
    // 画上温度和天气情况
    NSString *tempAndCond = [NSString stringWithFormat:@"%@℃ %@",controller.jsonDic[@"now"][@"tmp"],controller.jsonDic[@"now"][@"cond"][@"txt"]];
    [tempAndCond drawAtPoint:CGPointMake(tempX, tempY) withAttributes:dict];
    // 画上APP标记
    NSString *ts = @"天\n时";
    [ts drawInRect:CGRectMake(20, image.size.height - 80,40,80) withAttributes:dict];
    
    
    // 获得新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}



#pragma mark - 天气图片
+ (instancetype)stringWithWeather:(NSString *)weatherName
{
    UIImage *weatherImage;
    if ([weatherName isEqualToString:@"晴"]) {
        weatherImage = [UIImage imageNamed:@"qing"];
    }else if ([weatherName isEqualToString:@"多云"]){
        weatherImage = [UIImage imageNamed:@"duoyun"];
    }else if ([weatherName isEqualToString:@"晴间多云"]){
        weatherImage = [UIImage imageNamed:@"qingjianduoyun"];
    }else if ([weatherName isEqualToString:@"阴"] || [weatherName isEqualToString:@"雾霾"] || [weatherName isEqualToString:@"雾"] || [weatherName isEqualToString:@"霾"]){
        weatherImage = [UIImage imageNamed:@"yin"];
    }else if ([weatherName isEqualToString:@"小雪"] || [weatherName isEqualToString:@"阵雪"]){
        weatherImage = [UIImage imageNamed:@"xiaoxue"];
    }else if ([weatherName isEqualToString:@"阴转晴"]){
        weatherImage = [UIImage imageNamed:@"yinzhuanqing"];
    }else if([weatherName isEqualToString:@"小雨"]){
        weatherImage = [UIImage imageNamed:@"xiaoyu"];
    }else if ([weatherName isEqualToString:@"大雨"] || [weatherName isEqualToString:@"中雨"]){
        weatherImage = [UIImage imageNamed:@"dayu"];
    }else if([weatherName isEqualToString:@"雨转晴"] || [weatherName isEqualToString:@"阵雨"]){
        weatherImage = [UIImage imageNamed:@"yuzhuanqing"];
    }else if([weatherName isEqualToString:@"雷阵雨"]){
        weatherImage = [UIImage imageNamed:@"zhenyu"];
    }else if ([weatherName isEqualToString:@"暴雨"]){
        weatherImage = [UIImage imageNamed:@"baoyu"];
    }else if ([weatherName isEqualToString:@"雨夹雪"]){
        weatherImage = [UIImage imageNamed:@"yujiaxue"];
    }else if ([weatherName isEqualToString:@"冰雹"]){
        weatherImage = [UIImage imageNamed:@"bingbao"];
    }else{
        weatherImage = [UIImage imageNamed:@"qing"];
    }
    
    
    return weatherImage;
}


#pragma mark - 天气图片
+ (instancetype)stringWithSuggestion:(NSString *)suggestionName
{
    UIImage *suggestionImage;
    if ([suggestionName isEqualToString:@"洗车指数"]) {
        suggestionImage = [UIImage imageNamed:@"car"];
    }else if ([suggestionName isEqualToString:@"穿衣指数"]){
        suggestionImage = [UIImage imageNamed:@"dress"];
    }else if ([suggestionName isEqualToString:@"紫外线指数"]){
        suggestionImage = [UIImage imageNamed:@"uv"];
    }else if ([suggestionName isEqualToString:@"旅游指数"]){
        suggestionImage = [UIImage imageNamed:@"travl"];
    }else if ([suggestionName isEqualToString:@"感冒指数"]){
        suggestionImage = [UIImage imageNamed:@"flu"];
    }else{
        suggestionImage = [UIImage imageNamed:@"sport"];
    }
    
    
    return suggestionImage;
}

@end
