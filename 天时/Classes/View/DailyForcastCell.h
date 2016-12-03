//
//  DailyForcastCell.h
//  天时
//
//  Created by  Jierism on 16/9/21.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSDailyForecast;
@interface DailyForcastCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *condImg;
@property (weak, nonatomic) IBOutlet UILabel *cond;
@property (weak, nonatomic) IBOutlet UILabel *maxTmp;
@property (weak, nonatomic) IBOutlet UILabel *minTmp;

@property (nonatomic,strong) TSDailyForecast *dailyForecast;

// 提供一个类方法快速创建cell
+ (instancetype)DailyForecastCellWithTableView:(UITableView *)tableView;

@end
