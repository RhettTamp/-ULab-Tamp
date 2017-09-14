//
//  ULUserLabCreatView.h
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ULUserLabModel;
@interface ULUserLabCreatView : ULView

@property (nonatomic, strong) RACSubject *finishSubject;  /**< 完成信号 */
- (instancetype)initWithProjectId:(NSNumber *)projectId;
- (instancetype)initWithProjectId:(NSNumber *)projectId labModel:(ULUserLabModel *)model;
@property (nonatomic, assign) BOOL isEdit;  /**< <#comment#>  */
@end
