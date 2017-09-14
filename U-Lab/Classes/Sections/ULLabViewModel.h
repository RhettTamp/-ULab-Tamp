//
//  ULLabViewModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewModel.h"

@interface ULLabViewModel : ULViewModel

@property (nonatomic, strong) RACCommand *labCommand;  /**< 获取实验室信息 */
@property (nonatomic, assign) NSInteger labID;  /**< 实验室id */
@property (nonatomic, strong) RACCommand *memberCommand;  /**< 获取实验室成员 */
@property (nonatomic, strong) RACCommand *addMemberCommand;  /**< 添加成员申请 */
@property (nonatomic, strong) RACCommand *agreeCommand;  /**< 同意申请 */

@property (nonatomic, strong) RACCommand *friendCommand;  /**< 友好实验室 */
@property (nonatomic, strong) RACCommand *friendDealCommand;  /**< 成为友好实验室申请 */
@property (nonatomic, strong) RACCommand *applyFriendCommand;  /**< 成为友好实验室申请 */
@property (nonatomic, strong) RACCommand *changeCommand; /**< 修改实验室信息  */
@property (nonatomic, strong) RACCommand *relieveCommand;

@property (nonatomic, strong) RACSubject *memberSubject;  /**< <#comment#> */
@property (nonatomic, strong) RACSubject *addMemberSubject;  /**< <#comment#> */
@property (nonatomic, strong) RACSubject *friendSubject;
@property (nonatomic, strong) RACSubject *applyFriendSubject;
@property (nonatomic, strong) RACSubject *agreeSubject;
@property (nonatomic, strong) RACSubject *changeSubject;
@property (nonatomic, strong) RACSubject *relieveSubject;

@end
