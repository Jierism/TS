//
//  SearchBarViewController.h
//  天时
//
//  Created by  Jierism on 16/9/29.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cityName)(NSString *city);

@interface SearchBarViewController : UIViewController

@property (nonatomic,strong) cityName cityName;
@property (nonatomic,strong) UISearchBar *searchBar;

- (void)searchCityName:(cityName)cityName;

@end
