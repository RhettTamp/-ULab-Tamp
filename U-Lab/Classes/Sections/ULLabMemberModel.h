//
//  ULLabMemberModel.h
//  U-Lab
//
//  Created by 周维康 on 17/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULLabMemberModel : NSObject
@property (nonatomic, assign) NSInteger memberId;  /**< 用户ID */
@property (nonatomic, strong) NSString *memberName;  /**< 用户名字 */
@property (nonatomic, strong) NSString *memberPhone;  /**< 用户手机号 */
@property (nonatomic, strong) NSString *memberEmail;  /**< 用户邮箱 */
@property (nonatomic, strong) NSString *school;  /**< 学校 */
@property (nonatomic, assign) NSInteger labId;  /**< 实验室ID */
@property (nonatomic, strong) NSString *labName;  /**< 实验室名字 */
@property (nonatomic, strong) NSString *educational;  /**< 教育水平 */
@property (nonatomic, strong) NSString *research;  /**< 研究方向 */
@property (nonatomic, strong) NSNumber *applyId;  /**< applyId */
@property (nonatomic, strong) NSString *headImage;  /**< applyId */
@property (nonatomic, strong) NSNumber *role;
@property (nonatomic, strong) NSNumber *menberStatus;

@end
