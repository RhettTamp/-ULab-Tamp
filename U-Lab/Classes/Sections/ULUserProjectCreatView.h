//
//  ULUserProjectCreatView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/6.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULUserProjectCreatView : ULView

@property (nonatomic, strong) RACSubject *addSubject;  /**< 添加实验 */
@property (nonatomic, strong) RACSubject *finishSubject;  /**< 添加完实验 */
@property (nonatomic, strong) RACSubject *popSubject;  /**< POP */
@end
