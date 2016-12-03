//
//  SuggestionCell.m
//  天时
//
//  Created by  Jierism on 16/9/22.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "SuggestionCell.h"
#import "TSLifeSuggestion.h"
#import "UIImage+logo.h"

@implementation SuggestionCell



- (void)setLifeSuggestion:(TSLifeSuggestion *)lifeSuggestion
{
    _lifeSuggestion = lifeSuggestion;
    if ([lifeSuggestion.sutitle  isEqual: @"cw"]) {
        lifeSuggestion.sutitle = @"洗车指数";
    }else if([lifeSuggestion.sutitle  isEqual: @"drsg"]) {
        lifeSuggestion.sutitle = @"穿衣指数";
    }else if([lifeSuggestion.sutitle  isEqual: @"uv"]) {
        lifeSuggestion.sutitle = @"紫外线指数";
    }else if([lifeSuggestion.sutitle  isEqual: @"trav"]) {
        lifeSuggestion.sutitle = @"旅游指数";
    }else if([lifeSuggestion.sutitle  isEqual: @"flu"]) {
        lifeSuggestion.sutitle = @"感冒指数";
    }else if([lifeSuggestion.sutitle  isEqual: @"sport"]) {
        lifeSuggestion.sutitle = @"运动指数";
    }
    self.titleLabel.text = lifeSuggestion.sutitle;
    [self.titleImgView setImage:[UIImage stringWithSuggestion:lifeSuggestion.sutitle]];
    self.levelLabel.text = lifeSuggestion.level;
    self.sugLabel.text = lifeSuggestion.suggestionTxt;
}


+ (instancetype)SuggestionCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"suggestionCell";
    SuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SuggestionCell" owner:nil options:nil] lastObject];
    }
    [cell imageTransform];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 图片翻转
- (void)imageTransform
{
        [UIView animateWithDuration:1 animations:^{
            self.titleImgView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
