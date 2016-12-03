//
//  SuggestionCell.h
//  天时
//
//  Created by  Jierism on 16/9/22.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSLifeSuggestion;
@interface SuggestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *sugLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) TSLifeSuggestion *lifeSuggestion;
// 提供一个类方法快速创建cell
+ (instancetype)SuggestionCellWithTableView:(UITableView *)tableView;

@end
