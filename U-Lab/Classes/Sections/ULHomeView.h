//
//  ULHomeView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULHomeView : ULView

@property (nonatomic, strong) RACSubject *shareSubject;  /**< 共享物品 */
@property (nonatomic, strong) RACSubject *applyBuySubject;  /**< 申请购买 */
@property (nonatomic, strong) RACSubject *searchSubject;  /**< 搜索物品 */
@end
