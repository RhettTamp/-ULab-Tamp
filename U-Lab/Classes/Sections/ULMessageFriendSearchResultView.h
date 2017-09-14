//
//  ULMessageFriendSearchResultView.h
//  ULab
//
//  Created by 周维康 on 2017/6/10.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"

@interface ULMessageFriendSearchResultView : ULView

- (instancetype)initWithKey:(NSString *)key labArray:(NSArray *)array;
@property (nonatomic, strong) RACSubject *nextSubject;  /**< 跳转 */
@end
