//
//  TSMainViewController.m
//  天时
//
//  Created by  Jierism on 16/9/26.
//  Copyright © 2016年  Jierism. All rights reserved.
//

#import "TSMainViewController.h"
#import "ViewController.h"
#import "SearchBarViewController.h"
#import "MBProgressHUD.h"
#import "LLSlideMenu.h"
#import "Citys.h"
#import "Citys+CoreDataProperties.h"
#import "CheckNetworkStatus.h"
#import "Reachability.h"
#import "UIImage+logo.h"

#define Kwidth 170 //侧栏宽度


@interface TSMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

// 侧栏
@property (nonatomic,strong) LLSlideMenu *slideMenu;

// 侧栏里的tableview
@property (nonatomic,strong) UITableView *citysTableView;


@property (nonatomic,strong) UIPageViewController *pageController;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *viewControllerArr;      // 存放视图的数组
@property (nonatomic,assign) NSInteger curPage ;                     // 记录当前
@property (nonatomic,assign) NSInteger totalPages ;                  // 记录总页数
@property (nonatomic,strong) NSMutableArray *citys;                  // 存放城市名称的数组
@property (nonatomic,strong) NSMutableArray *allObjects;            // 存放数据记录的数组
@property (nonatomic,assign) BOOL cityIsUse;                            // 城市是否可用标记
@property (nonatomic,strong) UISwitch *refashSwitch;

@end

@implementation TSMainViewController
{
    UIImage *_image;                            // 从相册或者相机选择的图片
    UIActionSheet *_actionSheet;                // 选择提示
    UIImagePickerController *_imagePicker;      // 选取照片
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // 懒加载城市数组
    if (self.citys == nil) {
        self.citys = [NSMutableArray array];                            // 传入城市名字
    }
    
    if ([CheckNetworkStatus networkStatus]) {
        // 从CoreData中读取数据
        [self dataFetchRequest];
        // 初始化城市可用标记
        self.cityIsUse = YES;

        [self configureData];
        [self configureViews];
    }else{
        UIImage *disconnectImg = [UIImage imageNamed:@"disconnect"];
        UIImageView *disconnectView = [[UIImageView alloc] initWithImage:disconnectImg];
        disconnectView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:disconnectView];
        self.navigationItem.title = @"无网络连接";
        
        // 等待1.5秒，弹出窗口提示用户设置网络
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"无网络连接", nil) message:NSLocalizedString(@"请点击确认重新设置网络", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil, nil];
            [alertView show];
        });
    }
    // 注册通知观察者，当页面刷新时重新载入数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"didRefresh" object:nil];
    
    // 注册通知观察者，当程序从后台变为活跃时，调用isRefrash方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCheck) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 当应用进入后台时调用的方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

// alertView的协议方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![CheckNetworkStatus networkStatus]) {
            abort();
    }else{
        // 关闭侧栏
        [_slideMenu ll_closeSlideMenu];
  
    }
}


-(void)configureData{
    // 设置页面
    self.totalPages = self.citys.count + 1;
    self.curPage = 0;
    self.viewControllerArr = [NSMutableArray array];
    ViewController *defalutViewController =[[ViewController alloc]init]; // 默认页面
    defalutViewController.page = 0;
    defalutViewController.cityName = @"北京";
    
    
    [self.viewControllerArr addObject:defalutViewController];
    for (int i = 0; i<self.citys.count; i++) {
        ViewController *tempVC = [[ViewController alloc]init];
        tempVC.cityName = self.citys[i];
        tempVC.page = self.viewControllerArr.count;  // 标记视图的页码
        [self.viewControllerArr addObject:tempVC];
        // 添加页面
        NSArray *viewControllers =[NSArray arrayWithObjects:self.viewControllerArr.lastObject, nil];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.pageControl.numberOfPages = self.totalPages;  // 记录总页数
        self.pageControl.currentPage = self.viewControllerArr.count;    // 把当前页设置为刚添加的页面
        
        // ****判断城市是否可用
        if (![tempVC cityIsUsable]) {
            
            // 关闭菊花
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // 再新建一个提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"这个城市不存在";
            hud.offset = CGPointMake(0 , 0);
            [hud hideAnimated:YES afterDelay:2.f];
            
            [self.viewControllerArr removeObject:self.viewControllerArr.lastObject]; // 移除不可用的城市
            self.totalPages -- ;
            self.pageControl.currentPage = self.totalPages;
            self.pageControl.numberOfPages = self.viewControllerArr.count;
            [self.citys removeObject:self.citys.lastObject]; // 移除不可用的城市
            // 重新载入天气页面
            NSArray *viewControllers =[NSArray arrayWithObjects:self.viewControllerArr.lastObject, nil];
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            
            tempVC = self.viewControllerArr.lastObject;
            
            // 城市不可用
            self.cityIsUse = NO;
            return;
        }
        
    }
}

//
- (void)refreshData
{

    ViewController *tempVC = [[ViewController alloc] init];
    tempVC = self.viewControllerArr[self.pageControl.currentPage];
    
}



#pragma mark - 懒加载侧栏
- (LLSlideMenu *)slideMenu
{
    if (_slideMenu == nil) {
        // 初始化
        _slideMenu = [[LLSlideMenu alloc] init];
        [self.view addSubview:_slideMenu];
        // 设置菜单宽度
        _slideMenu.ll_menuWidth = Kwidth;
        // 设置菜单背景色
        _slideMenu.ll_menuBackgroundColor = [UIColor darkGrayColor];
        // 设置弹力和速度，  默认的是20,15,60
        _slideMenu.ll_springDamping = 20;       // 阻力
        _slideMenu.ll_springVelocity = 15;      // 速度
        _slideMenu.ll_springFramesNum = 60;     // 关键帧数量
        
        // 侧栏标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, Kwidth, 44)];
        label.text = @"管理城市";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [_slideMenu addSubview:label];
        // 添加一个tableview，用于管理城市
        _citysTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Kwidth, 132) style:UITableViewStylePlain];
        _citysTableView.backgroundColor = [UIColor clearColor];
        _citysTableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2]; // 修改tableView每行分隔线的颜色
//        _citysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _citysTableView.delegate = self;
        _citysTableView.dataSource = self;
        [_slideMenu addSubview:_citysTableView];
        
        // ***添加一个按钮
        UIButton *logoPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoPhotoBtn.frame = CGRectMake(20, 220, Kwidth - 40, 40);
        logoPhotoBtn.backgroundColor = [UIColor clearColor];
        [logoPhotoBtn setImage:[UIImage imageNamed:@"camera_L"] forState:UIControlStateNormal];
        [logoPhotoBtn setTitle:@" 天时水印" forState:UIControlStateNormal];
        [logoPhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoPhotoBtn.titleLabel.textColor = [UIColor whiteColor];
        // 添加按钮边框
        [logoPhotoBtn.layer setMasksToBounds:YES];
        [logoPhotoBtn.layer setCornerRadius:8.0];
        [logoPhotoBtn.layer setBorderWidth:1.0];
        // 设置按钮边框颜色
//        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,1});
        [logoPhotoBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [logoPhotoBtn addTarget:self action:@selector(showPhotoMenu) forControlEvents:UIControlEventTouchUpInside];
        [_slideMenu addSubview:logoPhotoBtn];
        
        // 自动更新
        UILabel *refrash = [[UILabel alloc] initWithFrame:CGRectMake(20, 495, Kwidth, 44)];
        refrash.text = @"自动更新";
        refrash.textColor = [UIColor whiteColor];
        refrash.backgroundColor = [UIColor clearColor];
        [_slideMenu addSubview:refrash];
        UILabel *refrashSub = [[UILabel alloc] initWithFrame:CGRectMake(20, 530, Kwidth, 20)];
        refrashSub.text = @"(每70分钟更新一次)";
        refrashSub.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        refrashSub.textColor = [UIColor whiteColor];
        refrashSub.backgroundColor = [UIColor clearColor];
        [_slideMenu addSubview:refrashSub];
        if (self.refashSwitch == nil) {
            self.refashSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 500, 51, 30)];
            [self.refashSwitch setOnTintColor:[UIColor colorWithRed:20/255.0 green:233/255.0 blue:215/255.0 alpha:1]];
            // 从沙盒中读取UISwitch的状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [self.refashSwitch setOn:[defaults boolForKey:@"switchStatus"]];
            [self.refashSwitch addTarget:self action:@selector(isRefrash:) forControlEvents:UIControlEventValueChanged];
            [_slideMenu addSubview:self.refashSwitch];
        }
    }
    return _slideMenu;
}

-(void)configureViews{
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:[[self view] bounds]];
    NSArray *viewControllers =[NSArray arrayWithObjects:self.viewControllerArr.firstObject, nil];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    // 创建UIPageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(40, 0, 40, 40)];
    self.pageControl.center = CGPointMake(self.view.bounds.size.width / 2.0,40);
    [self.pageControl addTarget:self action:@selector(pageSelected) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl.numberOfPages = self.totalPages;
    self.pageControl.currentPage = self.curPage;
    [self.view addSubview:self.pageControl];
    
    
    
    // 右按钮，添加城市
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(self.view.bounds.size.width - 54, 20, 44, 44);
    [addBtn setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    
    // 左按钮，更多功能
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(10, 20, 44, 44);
    [moreBtn setImage:[UIImage imageNamed:@"menu-4"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(More) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    
}

#pragma mark - 翻页方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    self.curPage = ((ViewController *)viewController).page;
    self.pageControl.currentPage = self.curPage;
    if (self.curPage < self.totalPages - 1 && self.curPage != self.totalPages) {
        return self.viewControllerArr[self.curPage + 1];
    }else{
        return nil;
    }
}



-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    self.curPage = ((ViewController *)viewController).page;
    self.pageControl.currentPage = self.curPage;
    if (self.curPage > 0 && self.curPage != self.totalPages) {
        return self.viewControllerArr[self.curPage - 1];
    }else{
        return nil;
    }
}

- (void)pageSelected
{
    
}

#pragma mark - 添加城市
-(void)addCity{
    SearchBarViewController *searchView = [[SearchBarViewController alloc] init];
    [self presentViewController:searchView animated:YES completion:^{
        [searchView searchCityName:^(NSString *cityName) {  // 从searchBar中传入字符串

            // 检测是否有网络，有则进行添加，否则提示
            if ([CheckNetworkStatus networkStatus])
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // 如果上面那句话之后就要在主线程执行一个长时间操作,那么要先延时一下让HUD先画好
                // 不然在执行任务前没画出来就显示不出来了
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.citys addObject:cityName];                // 将cityName加入citys数组中
                    [self configureData];
                    [self.citysTableView reloadData];               // 更新侧栏tableview的数据
                    
                    if (self.cityIsUse == YES) {
                        // ****把可用城市数据保存到数据库
                        Citys *citys = [NSEntityDescription insertNewObjectForEntityForName:@"Citys" inManagedObjectContext:self.managedObjectContext];
                        citys.cityName = cityName;
                        [self.allObjects addObject:citys];
                        [self SaveOrPerformError];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                    // 把标记重新设置为YES
                    self.cityIsUse = YES;
                });
                
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"无网络连接";
                hud.detailsLabel.text = @"添加失败";
                hud.offset = CGPointMake(0, 0);
                [hud hideAnimated:YES afterDelay:2.f];
            }
         
        }];
    }];

    

}

- (void)More{
    // 加入侧栏
    [self slideMenu];
    //===================
    // 打开菜单
    //===================

    if (_slideMenu.ll_isOpen) {
        [_slideMenu ll_closeSlideMenu];

    } else {
        [_slideMenu ll_openSlideMenu];
    }
    
}
#pragma mark -citysTableView的方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.citys.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityID];
    }
    cell.textLabel.text = self.citys[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"location_L"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 实现滑动删除手势
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.从数组中删除数据
    [self.citys removeObjectAtIndex:indexPath.row];
    
    // *****从数据库中删除数据
    [self.managedObjectContext deleteObject:self.allObjects[indexPath.row]];
    [self SaveOrPerformError];

    // 2.更新界面
    [self.citysTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    // 重新载入天气数据
    [self.viewControllerArr removeObjectAtIndex:indexPath.row + 1];
    [self configureData];
    NSArray *viewControllers =[NSArray arrayWithObjects:self.viewControllerArr.lastObject, nil];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageControl.numberOfPages = self.totalPages;
    self.pageControl.currentPage = self.viewControllerArr.count;
    
}

// 把cell的删除按钮设置为中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark - 数据库相关方法
// 查询数据，并显示
- (void)dataFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Citys"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext
                             executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil)
    {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
    
    // 用这个可变数组作为容器，存放查询出来的数据，用于方便往里面添加数据
    if (self.allObjects == nil) {
        self.allObjects = [NSMutableArray array];
    }
    
    for (Citys *city in foundObjects) {
        [self.allObjects addObject:city];
    }
    
    // 把数据库的数据放到citys数组，显示在citysTableView上
    for (Citys *city in self.allObjects)
    {
        [self.citys addObject:city.cityName];
    }
}

// 保存数据，如果出错则弹出提示
- (void)SaveOrPerformError
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        FATAL_CORE_DATA_ERROR(error);// 先弹出alert信息，用户取消后再终止程序
        return;
    }
}

#pragma mark - 自动更新

- (void)isRefrash:(UISwitch *)sender
{
    // [NSUserDefaults standardUserDefaults]可以直接操作偏好设置文件夹
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 自动帮我们生成一个plist文件存放在偏好设置的文件夹
    [defaults setBool:sender.on forKey:@"switchStatus"];
    
    // 同步：把内存中的数据和沙盒同步
    [defaults synchronize];
}
// 判断时间差，自动更新
- (void)timeCheck
{
    //若有网络则检测
    if ([CheckNetworkStatus networkStatus] && self.refashSwitch.on) {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        ViewController *tempVC = self.viewControllerArr.firstObject;
        NSString *str = tempVC.jsonDic[@"basic"][@"update"][@"loc"];
        NSDate *upDate = [dateformatter dateFromString:str];
        //获取当前时间与上次更新时间的时间差
        NSTimeInterval nowtime = [date timeIntervalSince1970];
        NSTimeInterval uptime = [upDate timeIntervalSince1970];
        
        double timeGap = (nowtime - uptime) / 60;
//        NSLog(@"\n%@\n%@\n%@\n",date,upDate,str);
//        NSLog(@"%f",timeGap);
        //若大于70分钟则刷新
        if (timeGap > 70) {
            //消息框提示
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = @"数据更新中";
            hud.offset = CGPointMake(0, 0);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self configureData];
                [hud hideAnimated:YES];
            });
        }
    }else if (![CheckNetworkStatus networkStatus] && self.refashSwitch.on){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"无网络连接,请检查你的网络";
        hud.offset = CGPointMake(0, 0);
        [hud hideAnimated:YES afterDelay:3.f];
    }
    
}

#pragma mark - 选取照片相关方法
// 当进入后台时，如果选取器没有关闭，就把它设置为nil，避免造成错误
- (void)applicationDidEnterBackground
{
    if (_imagePicker != nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
    if (_actionSheet != nil) {
        [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:NO];
        _actionSheet = nil;
    }
}

- (void)takePhoto
{
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.view.tintColor = self.view.tintColor;
    _imagePicker.allowsEditing = YES;
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

// 从相册里选择照片
- (void)choosePhotoFromLibrary
{
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    _imagePicker.view.tintColor = self.view.tintColor;
    _imagePicker.allowsEditing = YES;
    
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

- (void)showPhotoMenu
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"自己拍一张",@"从相册里面选择", nil];
        
        [_actionSheet showInView:self.view];
    }else{
        [self choosePhotoFromLibrary];
    }
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _image = info[UIImagePickerControllerEditedImage];
    //画出水印图片
    UIImage *newImg = [UIImage imageWithImage:_image andViewController:self.viewControllerArr[self.pageControl.currentPage]];
    UIImageWriteToSavedPhotosAlbum(newImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    // 把图片输出到桌面，用于调试
//    NSData *data = UIImagePNGRepresentation(newImg);
//    [data writeToFile:@"/Users/jierism/Desktop/newImg.png" atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _imagePicker = nil;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil;
    if (error != nil) {
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"确认", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    _imagePicker = nil;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1){
        [self choosePhotoFromLibrary];
    }
    _actionSheet = nil;
}


- (void)dealloc
{
    // 移除通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
