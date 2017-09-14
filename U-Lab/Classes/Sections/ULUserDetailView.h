//
//  ULUserDetailView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULUserDetailView : ULView

@property (nonatomic, strong) RACSubject *improveSubject;  /**< 完善信号 */
@property (nonatomic, strong) RACSubject *logoutSubject;  /**< 退出登录 */
@property (nonatomic, strong) RACSubject *changeSubject;  /**< <#comment#> */

@property (nonatomic, strong) UITextField * researchText;  /**< <#comment#> */
@property (nonatomic, strong) UITextField *schoolText;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *headerImageView;  /**< 头像 */
@property (nonatomic, strong) NSArray *detailArray;
- (void)reloadData;

@end
