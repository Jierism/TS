//
//  SearchBarViewController.m
//  天时
//
//  Created by  Jierism on 16/9/29.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "SearchBarViewController.h"

@interface SearchBarViewController ()<UISearchBarDelegate>

@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

// 使搜索栏成为第一响应者
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}

// search按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self returnCityName];
}

- (void)returnCityName{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.searchBar.text.length == 0) {
            return;
        }
        self.cityName(self.searchBar.text);
    }];
}

- (void)searchCityName:(cityName)cityName{
    self.cityName = cityName;
}

// 取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self cancel];
}

//修改CancleButton
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    for (UIView *canclebtns in [[[searchBar subviews]objectAtIndex:0]subviews]) {
        if ([canclebtns isKindOfClass:[UIButton class]]) {
            UIButton *cancleBtn = (UIButton*)canclebtns;
            
            [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancleBtn setTintColor:[UIColor whiteColor]];
            break;
        }
        
    }
}


-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 设置视图

- (void)configureViews{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder-16"]];
    backgroundImg.contentMode = UIViewContentModeScaleToFill;
    backgroundImg.frame = CGRectMake(self.view.bounds.size.width / 2 - 60, 180, 120, 85);
    [self.view addSubview:backgroundImg];
    
    [self.view addSubview:self.searchBar];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    headerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    titleLabel.text = @"添加城市";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
}

- (void)back
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载视图
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width , 50)];
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchBar.placeholder = @"请输入城市名字中文/拼音";
        _searchBar.barStyle = UIBarStyleBlackOpaque;
        _searchBar.delegate = self;
        
        
    }
    return _searchBar;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
