//
//  ULStack.h
//  ULab
//
//  Created by 谭培 on 2017/7/20.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULQueueTool : NSObject

- (void)enQueue:(id)object;

- (void)deQueue;

- (NSArray *)getQueue;

@end
