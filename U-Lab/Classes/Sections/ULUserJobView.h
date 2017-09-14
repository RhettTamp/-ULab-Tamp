//
//  ULUserJobView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULUserJobView : ULView

@property (nonatomic, strong) RACSubject *updateViewSubject;  /**< 更新世图 */
@property (nonatomic, strong) RACSubject *nextSubject;  /**< <#comment#> */
@end
