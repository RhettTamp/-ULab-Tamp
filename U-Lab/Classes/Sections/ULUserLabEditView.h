//
//  ULUserLabEditView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULUserLabEditView : ULView

@property (nonatomic, strong) RACSubject *cellSelectSubject;  /**< select */
- (instancetype)initWithLabArray:(NSArray *)labArray;

- (void)updateViewWithArray:(NSArray *)array;
@end
