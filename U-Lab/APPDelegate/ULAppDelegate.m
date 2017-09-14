//
//  AppDelegate.m
//  U-Lab
//
//  Created by 周维康 on 17/5/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULAppDelegate.h"
#import "ULLoginViewController.h"
#import "ULNavigationController.h"
#import "ULHomeViewController.h"
#import "ULTabBarController.h"
#import "ULLoginViewController.h"
#import "ULMessageFriendViewModel.h"
#import "ULAppDelegate+Service.h"
#import "JPUSHService.h"
// 引入JPush功能所需头文件
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface ULAppDelegate ()

@end

@implementation ULAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // Required - 启动 JMessage SDK
    [JMessage setupJMessage:launchOptions appKey:jMessageAppKey channel:nil apsForProduction:YES category:nil messageRoaming:NO];
    [self registerJMessage];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JMessage setDebugMode];
    
    [self regesterJPush];
    
    [self initJPushWithLaunchOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"private_user_account"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"];
    if (account&&password)
    {
        [self loginJMessage];
//        [self refreshUserInfo];
        ULHomeViewController *homeVC = [[ULHomeViewController alloc] init];
        ULNavigationController *navigationC = [[ULNavigationController alloc] initWithRootViewController:homeVC];
//        NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (remoteNotification) {
////            [homeVC.tabBarController.tabBar showBadgeOnItmIndex:1];
//        }
        navigationC.navigationBar.hidden = YES;
        self.window.rootViewController = navigationC;
    } else {
        ULLoginViewController *loginVC = [[ULLoginViewController alloc] init];
        ULNavigationController *navigationC = [[ULNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navigationC;
    }
    self.window.backgroundColor = kCommonWhiteColor;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:completionHandler{
    
}
/*
 * @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param response 通知响应对象
 * @param completionHandler
 */

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSInteger badge = [[NSUserDefaults standardUserDefaults] integerForKey:@"badge"];
    badge ++;
    [[NSUserDefaults standardUserDefaults]setInteger:badge forKey:@"badge"];
}

- (void)loginJMessage{
    NSString *account;
    if ([ULUserMgr sharedMgr].regType == 0) {
        account = [ULUserMgr sharedMgr].userPhone;
    }else{
        account = [ULUserMgr sharedMgr].userEmail;
    }
    [JMSGUser loginWithUsername:account password:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"] completionHandler:^(id resultObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    switch (event.eventType) {
        case kJMSGEventNotificationCurrentUserInfoChange: {
            [ULProgressHUD showWithMsg:@"用户信息已变更，请重新登录"];
            [[ULUserMgr sharedMgr] removeMgr];
            NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:[ULUserMgr sharedMgr]];
            [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"ulab_user"];
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionReveal;
            animation.subtype = kCATransitionFromBottom;
            [self.window.layer addAnimation:animation forKey:nil];
            //    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
            ULLoginViewController *loginVC = [[ULLoginViewController alloc] init];
            ULNavigationController *navigationC = [[ULNavigationController alloc] initWithRootViewController:loginVC];
            [[self currentViewController] presentViewController:navigationC animated:NO completion:nil];
        }
            break;
        case kJMSGEventNotificationReceiveFriendInvitation: {
            JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[ULUserMgr sharedMgr].addFriendArray addObject:[friendEvent getFromUser]];
        }
            break;
        case kJMSGEventNotificationAcceptedFriendInvitation: {
            JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[ULUserMgr sharedMgr].friendArray addObject:[friendEvent getFromUser]];
        }
            break;
        case kJMSGEventNotificationDeclinedFriendInvitation: {
            
        }
            break;
        case kJMSGEventNotificationDeletedFriend: {
            
            JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[ULUserMgr sharedMgr].friendArray removeObject:[friendEvent getFromUser]];
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate: {
            
        }
            break;
        case kJMSGEventNotificationLoginKicked: {
            [ULProgressHUD showWithMsg:@"您的账号已在其他地方登录"];
            [[ULUserMgr sharedMgr] removeMgr];
            NSData *archiveUserData = [NSKeyedArchiver archivedDataWithRootObject:[ULUserMgr sharedMgr]];
            [[NSUserDefaults standardUserDefaults] setObject:archiveUserData forKey:@"ulab_user"];
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionReveal;
            animation.subtype = kCATransitionFromBottom;
            [self.window.layer addAnimation:animation forKey:nil];
            //    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
            ULLoginViewController *loginVC = [[ULLoginViewController alloc] init];
            ULNavigationController *navigationC = [[ULNavigationController alloc] initWithRootViewController:loginVC];
            [[self currentViewController] presentViewController:navigationC animated:NO completion:nil];
            
        }
            break;
        case kJMSGEventNotificationServerAlterPassword:
            NSLog(@"Server Alter Password Event ");
            break;
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"User login status unexpected Event ");
            break;
        default:
            NSLog(@"Other Notification Event ");
            break;
    }
}

-(UIViewController *)currentViewController
{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    
    return currVC;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error
{
    NSNumber *errCode;
    if (error)
    {
        errCode = @1;
    } else {
        errCode = @0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveFriendMessageNotification object:@{@"message" : message,
                                                                                                          @"error": errCode} userInfo:nil];
}

- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error
{
    NSNumber *errCode;
    if (error)
    {
        errCode = @1;
    } else {
        errCode = @0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendFriendMessageNotification object:@{@"message" : message,
                                                                                                       @"error":errCode} userInfo:nil];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
