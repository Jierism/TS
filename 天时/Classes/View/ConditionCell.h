//
//  ConditionCell.h
//  天时
//
//  Created by  Jierism on 16/9/24.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSCondition;
@interface ConditionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *conditionImg;
@property (weak, nonatomic) IBOutlet UILabel *condLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherQltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowTmpLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirLabel;
@property (weak, nonatomic) IBOutlet UILabel *windScLabel;
@property (nonatomic,strong) TSCondition *condition;



// 提供一个类方法快速创建cell
+ (instancetype)ConditionCellWithTableView:(UITableView *)tableView;

// 图片翻转
- (void)imageTransform;
@end
