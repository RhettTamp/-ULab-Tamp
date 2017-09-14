//
//  ULHomeMainViewController.h
//  U-Lab
//
//  Created by 周维康 on 17/5/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"

@interface ULHomeMainViewController : ULViewController

@property (nonatomic, strong) RACSubject *actionSubject;  /**< 个人信息点击 */
@property (nonatomic, strong) RACSubject *appearSubject;  /**< appear */
@property (nonatomic, strong) RACSubject *disappearSubject;  /**< disappear */
@end
