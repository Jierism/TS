//
//  ConditionCell.m
//  天时
//
//  Created by  Jierism on 16/9/24.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "ConditionCell.h"
#import "TSCondition.h"
#import "UIImage+logo.h"


@implementation ConditionCell


- (void)setCondition:(TSCondition *)condition
{

    [self.conditionImg setImage:[UIImage stringWithWeather:condition.nowCond]];
    self.condLabel.text = condition.nowCond;
    if (condition.weatherqlty == nil) {
        condition.weatherqlty = @"不详";
    }
    self.weatherQltyLabel.text = [NSString stringWithFormat:@"空气质量：%@",condition.weatherqlty];
    self.nowTmpLabel.text = [NSString stringWithFormat:@"%@℃",condition.nowTmp];
    self.windDirLabel.text = condition.winddir;
    self.windScLabel.text = [NSString stringWithFormat:@"%@级",condition.windsc];

}

+ (instancetype)ConditionCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"conditionCell";
    
    ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConditionCell" owner:nil options:nil] lastObject];
    }
    [cell imageTransform];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 图片翻转
- (void)imageTransform
{
    if ([self.condLabel.text isEqualToString:@"晴"]) {
        [UIView animateWithDuration:1 animations:^{
            self.conditionImg.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }];

    }else{
        [UIView animateWithDuration:1 animations:^{
            self.conditionImg.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        }];
        
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
