//
//  ULLabSearchView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
#import "ULSearchLabViewModel.h"

@interface ULLabSearchView : ULView

@property (nonatomic, strong) RACSubject *searchSubject;  /**< 搜索信号 */
@property (nonatomic, strong) ULSearchLabViewModel *viewModel;  /**< VM */
@property (nonatomic,assign) BOOL isFirstShow;

@end
