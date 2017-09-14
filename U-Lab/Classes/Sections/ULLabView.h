//
//  ULLabView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULLabView : ULView

@property (nonatomic, strong) RACSubject *nextControllerSubject;  /**< 跳转 */
@property (nonatomic, assign) BOOL isShowNewsView;
- (void)updateLabView;
@end
