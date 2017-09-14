//
//  ULUserObjectModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/5/31.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULUserObjectModel : NSObject

@property (nonatomic, assign) NSInteger objectId;  /**< 物品id */
//@property (nonatomic, strong) NSString *itemId;  /**< 物品id */

@property (nonatomic, copy) NSString *objectName;  /**< 物品名称 */
@property (nonatomic, assign) NSInteger objectType;  /**< 物品类型 */
@property (nonatomic, assign) NSInteger objectQuantity;  /**< 物品数量 */
@property (nonatomic, copy) NSString *objectLocation;  /**< 物品存放地址 */
@property (nonatomic, assign) NSInteger amount;  /**< 价格*/
@property (nonatomic, assign) NSInteger userId;  /**< 使用者id  */
@property (nonatomic, assign) NSInteger laboratoryId;  /**< 物品存放地址 */

@property (nonatomic, copy) NSString *userName;  /**< 使用者姓名 */
@property (nonatomic, copy) NSString *userLabName;  /**< 使用者实验室 */
@property (nonatomic, copy) NSString *ownerName;  /**< 用户名字 */
@property (nonatomic, copy) NSString *contactNumber;  /**< 使用电话 */
@property (nonatomic, assign) NSInteger ownerId;  /**< 拥有者id  */
@property (nonatomic, assign) NSInteger labId;  /**< 实验室id  */
@property (nonatomic, assign) CGFloat price;  /**< 价格  */
@property (nonatomic, copy) NSString *measureUnit;  /**< 测量单位 */
@property (nonatomic, copy) NSString *factory;  /**< 工厂、厂家 */
@property (nonatomic, copy) NSString *specification;  /**< 规格、型号 */
@property (nonatomic, copy) NSString *dealer;  /**< 经销商 */
@property (nonatomic, copy) NSString *objectDescription;  /**< 描述 */
@property (nonatomic, copy) NSString *imageURL;  /**< 图片描述 */
@property (nonatomic, strong) NSNumber *isUsing;  /**< 是否使用 */
@property (nonatomic, strong) NSNumber *isShared;  /**< 是否共享 */
@property (nonatomic, copy) NSString *servicePhone;  /**< 服务电话 */
@property (nonatomic, strong) NSNumber *status;  /**< status */
@property (nonatomic, copy) NSString *time;  /**< 入库时间 */


@end

