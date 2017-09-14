//
//  OLHomeKeyView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/19.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULHomeKeyView : ULView

- (instancetype)initWithKeyArray:(NSArray *)keyArray;
- (void)reloadData;
@property (nonatomic, strong) RACSubject *touchSubject;  /**< 点击标签 */
@property (nonatomic, strong) NSMutableArray *keyArray;  /**< 关键字数组 */

@end
