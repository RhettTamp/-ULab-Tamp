//
//  ULUserLabDetailView.h
//  ULab
//
//  Created by 周维康 on 2017/6/12.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@class ULUserLabModel;
@interface ULUserLabDetailView : ULView

- (instancetype)initWithLabModel:(ULUserLabModel *)labModel;
- (void)uploadWithModel:(ULUserLabModel *)model;

@end
