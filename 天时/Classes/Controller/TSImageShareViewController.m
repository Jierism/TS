//
//  TSImageShareViewController.m
//  天时
//
//  Created by  Jierism on 2017/1/19.
//  Copyright © 2017年  Jierism. All rights reserved.
//

#import "TSImageShareViewController.h"
#import <UShareUI/UShareUI.h>

@interface TSImageShareViewController ()<UIAlertViewDelegate>

@end

@implementation TSImageShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 380)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(20, 500, 88, 44);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.textColor = [UIColor whiteColor];
    [shareBtn addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIButton *cancellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancellBtn.frame = CGRectMake(220, 500, 88, 44);
    [cancellBtn setTitle:@"返回" forState:UIControlStateNormal];
    cancellBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancellBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancellBtn];
    
}

- (void)back
{
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)shareImage
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareImageToPlatformType:platformType];
    }];
}

//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图本地
//    shareObject.thumbImage = self.image;
    
    [shareObject setShareImage:self.image];
    
    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
        [self setPinterstInfo:messageObject];
    }
    
    // 设置Kakao参数
    if (platformType == UMSocialPlatformType_KakaoTalk) {
        messageObject.moreInfo = @{@"permission" : @1}; // @1 = KOStoryPermissionPublic
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"取消分享"];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    messageObj.moreInfo = @{@"app_name": @"天时",
                            @"suggested_board_name": @"天时出品",
                            @"description": @"天时：一款简约的天气预报"};
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
