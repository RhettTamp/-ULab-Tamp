//
//  ULUserOrderModel.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/2.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULUserOrderModel : NSObject

@property (nonatomic, assign) NSInteger orderId;  /**< 订单id  */
@property (nonatomic, strong) NSString *senderName;  /**< 借出方名字 */
@property (nonatomic, assign) NSInteger senderId;  /**< 借出方id  */
@property (nonatomic, strong) NSString *receiverName;  /**< 借入方name */
@property (nonatomic, assign) NSInteger receiverId;  /**< <#comment#>  */
@property (nonatomic, strong) NSString *orderTime;  /**< <#comment#> */
@property (nonatomic, assign) NSInteger itemId;  /**< 物品id  */
@property (nonatomic, strong) NSString *orderQuantity;  /**< <#comment#> */
@property (nonatomic, strong) NSString *senderPhone;  /**< <#comment#> */
@property (nonatomic, assign) NSInteger orderStatus;  /**< <#comment#>  */
@property (nonatomic, assign) NSInteger orderAmount;  /**< <#comment#>  */
@property (nonatomic, assign) NSInteger labId;  /**< <#comment#>  */
@property (nonatomic, strong) NSString *orderName;  /**< 物品名 */
@property (nonatomic, strong) NSString *imageURL;  /**< 头像 */
@property (nonatomic, assign) NSInteger status;  /**< 状态 */
@property (nonatomic, assign) NSInteger itemType;  /**< 头状态 */


@end
