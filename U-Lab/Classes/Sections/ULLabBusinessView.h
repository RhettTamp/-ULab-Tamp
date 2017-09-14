//
//  ULLabBusinessView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/8.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULLabBusinessView : ULView

@property (nonatomic, strong) RACSubject *nextSubject;  /**< subject */
@property (nonatomic, strong) UITextField *introLabel;
@property (nonatomic, strong) RACSubject *totleSubject;
@property (nonatomic,strong) UIView *pickerView;;

@end
