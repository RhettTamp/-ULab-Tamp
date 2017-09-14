//
//  ULAppDelegate+Service.m
//  ULab
//
//  Created by 谭培 on 2017/8/2.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULAppDelegate+Service.h"
#import "JPUSHService.h"

@interface ULAppDelegate ()<JMessageDelegate, JMSGMessageDelegate,JPUSHRegisterDelegate>

@end

@implementation ULAppDelegate (Service)

- (void)loginJMSG{
    [JMSGUser loginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"JMSG login success");
        }
    }];
}

- (void)registerJMessage{
    // Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    }
}

- (void)regesterJPush{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

- (void)initJPushWithLaunchOption:(NSDictionary *)option{
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //    static NSString *jPushChannel = @"Publish channel";
    [JPUSHService setupWithOption:option appKey:jMessageAppKey
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
}

- (void)refreshUserInfo{
    ULBaseRequest *request = [[ULBaseRequest alloc]init];
    [request getDataWithParameter:nil session:YES progress:nil success:^(ULBaseRequest *request, NSDictionary *responseObject) {        NSDictionary *dic = responseObject[@"data"];
        if (dic) {
            [[ULUserMgr sharedMgr] yy_modelSetWithJSON:dic];
            [ULUserMgr saveMgr];
        }
        
    } failure:^(ULBaseRequest *request, NSError *error) {
        
    } withPath:@"ulab_user/users/info"];
}

@end
