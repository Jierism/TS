//
//  ViewController.h
//  天时
//
//  Created by  Jierism on 16/9/18.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *cityLabel;     // 城市名字
@property (nonatomic,strong) UILabel *date;         // 显示日期

@property (nonatomic,strong) NSDictionary *jsonDic;         // 用于字典参数的传递（主页天气）
@property (nonatomic,strong) NSArray *dailyDic;      // 用于字典转数组（每日天气）
@property (nonatomic,strong) NSMutableArray *conditon;  // 当前天气容器
@property (nonatomic,strong) NSMutableArray *dailyFc;   // 每日天气容器
@property (nonatomic,strong) NSMutableArray *lifeSuggestion;    // 生活指数容器
@property (nonatomic,assign) NSInteger page;            // 页码
@property (nonatomic,copy) NSString *cityName;


// 判断城市是否可用
- (BOOL)cityIsUsable;


@end

