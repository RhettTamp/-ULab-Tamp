//
//  ULLendApplyView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
@class ULUserOrderModel;
@interface ULLendApplyView : ULView

- (instancetype)initWithModel:(ULUserOrderModel *)model andType:(NSNumber *)type;

@end
