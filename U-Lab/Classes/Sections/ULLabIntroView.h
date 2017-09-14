//
//  ULLabIntroView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/7.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@class ULLabModel;
@interface ULLabIntroView : ULView

- (instancetype)initWithModel:(ULLabModel *)model;
@property (nonatomic,strong) ULLabModel *model;
- (void)reloadData;
@end
