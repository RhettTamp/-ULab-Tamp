//
//  ULHomeUserView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/20.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULHomeUserView : ULView
@property (nonatomic, strong) RACSubject *selectSubject;  /**< 点击列表 */
- (void)updateUserView;
@end
