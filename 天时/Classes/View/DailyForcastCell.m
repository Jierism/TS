//
//  DailyForcastCell.m
//  天时
//
//  Created by  Jierism on 16/9/21.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "DailyForcastCell.h"
#import "TSDailyForecast.h"
#import "UIImage+logo.h"

@interface DailyForcastCell()



@end

@implementation DailyForcastCell

- (void)setDailyForecast:(TSDailyForecast *)dailyForecast
{
    _dailyForecast = dailyForecast;
    NSString *date = [dailyForecast.date substringFromIndex:5]; // 抽取日期子串
    self.date.text = date;
    [self.condImg setImage:[UIImage stringWithWeather:dailyForecast.cond]];
    self.cond.text = dailyForecast.cond;
    self.maxTmp.text = dailyForecast.maxTmp;
    self.minTmp.text = dailyForecast.minTmp;
}


+ (instancetype)DailyForecastCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Cell";
    
    DailyForcastCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DailyForcastCell" owner:nil options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
