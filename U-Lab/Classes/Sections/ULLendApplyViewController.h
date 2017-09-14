//
//  ULLendApplyViewController.h
//  U-Lab
//
//  Created by 周维康 on 17/5/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULViewController.h"
@class ULUserOrderModel;
@interface ULLendApplyViewController : ULViewController
- (instancetype)initWithModel:(ULUserOrderModel *)model andType:(NSNumber*)type;  //借入0，借出1
@end
