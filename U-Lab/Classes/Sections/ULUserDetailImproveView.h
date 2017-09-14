//
//  ULUserDetailImproveView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULUserDetailImproveView : ULView

@property (nonatomic, copy) NSString *userName;  /**< 用户名 */
@property (nonatomic, copy) NSString *labName;  /**< 实验室名 */
@property (nonatomic, strong) NSNumber *sex;  /**< sex */
@property (nonatomic, strong) NSNumber *role;  /**< role */
@property (nonatomic, strong) NSString *location;  /**< location */
@end
