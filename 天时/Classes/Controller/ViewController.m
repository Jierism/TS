//
//  ViewController.m
//  天时
//
//  Created by  Jierism on 16/9/18.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "ViewController.h"
// 数据模型头文件
#import "TSCondition.h"
#import "TSDailyForecast.h"
#import "TSLifeSuggestion.h"
// XIB视图头文件
#import "SuggestionCell.h"
#import "ConditionCell.h"
#import "DailyForcastCell.h"
// 下拉刷新
#import "MJRefresh.h"
// 检查网络
#import "CheckNetworkStatus.h"
// 第三方HUD
#import "MBProgressHUD.h"

#define TSBGCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMainView];
    [self configureDatawithcity:self.cityName];
    // 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self configureDatawithcity:self.cityName];
        [self loadMainView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didRefresh" object:self];
        [self.tableView.mj_header endRefreshing];
    }];

    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.tableView.mj_header = header;
}







- (void)configureDatawithcity: (NSString *)cityName{
    NSString *httpUrl = [NSString stringWithFormat:@"https://free-api.heweather.com/v5/weather?city=%@&key=7fcf60e8809f4c96a66ee7d1bb3c6fc0",[cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:httpUrl]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *jsonArr = [jsonDict objectForKey:@"HeWeather5"];
    NSDictionary *jsonDictionary = [jsonArr objectAtIndex:0];
    //NSLog(@"%@",jsonDictionary);
    self.jsonDic = jsonDictionary;
    [self setAllData];
}

// 判断城市是否可用
- (BOOL)cityIsUsable
{
    if ([self.jsonDic[@"status"] isEqualToString:@"unknown city"]) {
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载视图

- (void)loadMainView{
    [self tableView];
    [self scrollView];
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 68)];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_scrollView];
        // 取消水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        // 显示城市
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.bounds.size.width, 30)];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:_cityLabel];
        
    }
    return _scrollView;
}


// 设置单元格视图
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 132, self.view.bounds.size.width, self.view.bounds.size.height - 132) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2]; // 修改tableView每行分隔线的颜色
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark - 设置天气数据
// 设置所有数据
- (void)setAllData
{
    [self setWeatherCondition];
    [self getDailyForecast];
    [self getLifeSuggestion];
}

// 主页天气
- (void)setWeatherCondition
{
    self.conditon = [NSMutableArray array];
    TSCondition *dic = [MTLJSONAdapter modelOfClass:[TSCondition class] fromJSONDictionary:self.jsonDic error:nil];
    self.cityLabel.text = dic.cityName;
    [self.conditon addObject:dic];
    
    // 根据天气改变背景颜色
    if ([dic.nowCond isEqualToString:@"晴"]) {
        self.view.backgroundColor = TSBGCOLOR(255, 80, 100);
    }else if ([dic.nowCond isEqualToString:@"多云"]){
        self.view.backgroundColor = TSBGCOLOR(0, 92, 130);
    }else if ([dic.nowCond isEqualToString:@"晴间多云"]){
        self.view.backgroundColor = TSBGCOLOR(0, 128, 255);
    }else if ([dic.nowCond isEqualToString:@"阴"] || [dic.nowCond isEqualToString:@"雾霾"] || [dic.nowCond isEqualToString:@"霾"]  || [dic.nowCond isEqualToString:@"雾"]){
        self.view.backgroundColor = [UIColor grayColor];
    }else if ([dic.nowCond isEqualToString:@"小雪"] || [dic.nowCond isEqualToString:@"阵雪"]){
        self.view.backgroundColor = TSBGCOLOR(0, 164, 164);
    }else if ([dic.nowCond isEqualToString:@"阴转晴"]){
        self.view.backgroundColor = TSBGCOLOR(0, 115, 228);
    }else if([dic.nowCond isEqualToString:@"小雨"] || [dic.nowCond isEqualToString:@"阵雨"]){
        self.view.backgroundColor = TSBGCOLOR(0, 80, 255);
    }else if ([dic.nowCond isEqualToString:@"大雨"] || [dic.nowCond isEqualToString:@"中雨"]){
        self.view.backgroundColor = TSBGCOLOR(0, 30, 180);
    }else if([dic.nowCond isEqualToString:@"雨转晴"]){
        self.view.backgroundColor = TSBGCOLOR(255, 70, 255);
    }else if([dic.nowCond isEqualToString:@"雷阵雨"]){
        self.view.backgroundColor = TSBGCOLOR(0, 40, 129);
    }else if ([dic.nowCond isEqualToString:@"暴雨"]){
        self.view.backgroundColor = TSBGCOLOR(0, 0, 175);
    }else if ([dic.nowCond isEqualToString:@"雨夹雪"]){
        self.view.backgroundColor = TSBGCOLOR(0, 70, 70);
    }else if ([dic.nowCond isEqualToString:@"冰雹"]){
        self.view.backgroundColor = TSBGCOLOR(0, 125, 140);
    }
    
    
}



// 每日天气
- (void)getDailyForecast
{

    NSArray *daily = [self.jsonDic objectForKey:@"daily_forecast"];
    self.dailyFc = [NSMutableArray array];
    TSDailyForecast *dic = [[TSDailyForecast alloc]init];
    for (int i = 0; i < [daily count]; i++) {
        NSDictionary *dailyDic = [daily objectAtIndex:i];
        dic = [MTLJSONAdapter modelOfClass:[TSDailyForecast class] fromJSONDictionary:dailyDic error:nil];
        
        [self.dailyFc addObject:dic];
    
    }

}


// 生活指数
- (void)getLifeSuggestion
{
    self.lifeSuggestion = [NSMutableArray array];
    NSDictionary *suggestion = [self.jsonDic objectForKey:@"suggestion"];
    // 根据字典里的key遍历，并取出使用
    
    [suggestion enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 自定义一个字典，存放模型
        NSMutableDictionary *sugDic = [[NSMutableDictionary alloc] init];
        NSDictionary *su = [suggestion objectForKey:key];
        [sugDic setObject:su forKey:@"text"];
        [sugDic setValue:key forKey:@"title"];
        
        TSLifeSuggestion *ls = [MTLJSONAdapter modelOfClass:[TSLifeSuggestion class] fromJSONDictionary:sugDic error:nil];
        // 除了@“comf”，其他数据都加到数组里面
        if (![ls.sutitle  isEqual: @"comf"] && ![ls.sutitle isEqualToString:@"air"]) {
            [self.lifeSuggestion addObject:ls];
        }
        
    }];
    
}


#pragma mark -UItableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.conditon count];
    }else if(section == 1){
        return [self.dailyFc count];
    }else{
        return [self.lifeSuggestion count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ConditionCell *conditionCell = [ConditionCell ConditionCellWithTableView:tableView];
        conditionCell.condition = self.conditon[indexPath.row];
        return conditionCell;
    }else if (indexPath.section == 1) {
        
        DailyForcastCell *dailyCell = [DailyForcastCell DailyForecastCellWithTableView:tableView];
        dailyCell.dailyForecast = self.dailyFc[indexPath.row];
        return dailyCell;
    }else{

        SuggestionCell *suggestionCell = [SuggestionCell SuggestionCellWithTableView:tableView];
        suggestionCell.lifeSuggestion = self.lifeSuggestion[indexPath.row];
        return suggestionCell;
    }
    
}

// 定义headerVIew
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 一定要在这里设置颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *ID = @"header";
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    header.contentView.backgroundColor = self.view.backgroundColor;
    
    if (section == 0) {
        return nil;
    }else if (section == 1){
        header.textLabel.text = @"天气预报";
        return header;
    }
    header.textLabel.text = @"生活小贴士";
    return header;
    
}



// 设置headerVIew的行高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 40;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {           // 设置主页天气Cell的高度
        return 436;
    }else if (indexPath.section == 1) {     // 设置每日预报Cell的高度
        return 44;
    }else{                                  // 设置生活指数Cell的高度
            return 136;
    }
}





@end
