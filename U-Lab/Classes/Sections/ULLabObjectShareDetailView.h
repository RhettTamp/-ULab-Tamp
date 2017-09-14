//
//  ULLabObjectUseDetailView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/9.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
@class ULUserObjectModel;
@interface ULLabObjectShareDetailView : ULView

- (instancetype)initWithModel:(ULUserObjectModel *)model;
@property (nonatomic, strong) RACSubject *subject;  /**< <#comment#> */
@end
