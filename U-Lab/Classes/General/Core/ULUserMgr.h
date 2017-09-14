//
//  ULUserMgr.h
//  U-Lab
//
//  Created by 周维康 on 17/5/17.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULUserMgr : NSObject

@property (nonatomic, strong) NSString *userName;  /**< 姓名 */
@property (nonatomic, strong) NSString *userPhone;  /**< 手机号 */
@property (nonatomic, strong) NSString *userEmail;  /**< 邮箱 */
@property (nonatomic, assign) NSInteger laboratoryId;  /**< 实验室id */
@property (nonatomic, strong) NSString *laboratoryName;  /**< 实验室名字 */
@property (nonatomic, strong) NSString *school;  /**< 学校名字 */
//@property (nonatomic, strong) NSString *educational;  /**< 学历 */
@property (nonatomic, strong) NSString *research;  /**< 个人研究方向 */
@property (nonatomic, strong) NSString *verify;  /**< 是否验证 */
@property (nonatomic, strong) NSString *status;  /**< 验证是否成功 */
@property (nonatomic, strong) UIImage *avaterImage;  /**< 头像 */
@property (nonatomic,strong) NSString *avaterImageUrl;

@property (nonatomic, strong) NSNumber *userId;  /**< userId */
@property (nonatomic, strong) NSNumber *sex;  /**< 性别 */
@property (nonatomic, strong) NSNumber *role;  /**< 身份 */
@property (nonatomic, strong) NSString *labLocation;  /**< labLocation */

@property (nonatomic, copy) NSString *labIntro;  /**< 实验室介绍 */
@property (nonatomic, copy) NSString *labResearch;  /**< 研究方向 */
@property (nonatomic, copy) NSString *labSetTime;  /**< 实验室建立时间 */
@property (nonatomic, copy) NSString *labImage;  /**< 实验室图片 */
@property (nonatomic, copy) NSString *labPiName;  /**< <#comment#> */
@property (nonatomic, copy) NSNumber *labMoney;  /**< 实验室余额  */
@property (nonatomic, assign) NSInteger labPi;  /**< pi  */
@property (nonatomic, assign) NSInteger score;  /**< 积分  */
@property (nonatomic, assign) NSInteger regType;  //0是手机注册
@property (nonatomic, strong) NSMutableArray<JMSGUser *> *friendArray;  /**< 好友列表 */
@property (nonatomic, strong) NSMutableArray<JMSGUser *> *addFriendArray;  /**< 好友添加申请 */
@property (nonatomic, strong) NSMutableArray *groupArray;  /**< 群数组 */
@property (nonatomic, strong) NSMutableArray *firendLabArray; /**< 友好实验室  */
@property (nonatomic, strong) NSArray *searchArray;
+ (ULUserMgr *)sharedMgr;

- (void)removeMgr;

+ (void)saveMgr;
@end
