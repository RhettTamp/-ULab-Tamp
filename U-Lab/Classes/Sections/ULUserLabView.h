//
//  ULUserLabView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/30.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
#import "ULUserLabViewModel.h"
@interface ULUserLabView : ULView

@property (nonatomic, strong) ULUserLabViewModel *viewModel;  /**< VM */
@property (nonatomic, strong) RACSubject *nextSubject;  /**< next */
- (void)updateLabView;
@end
