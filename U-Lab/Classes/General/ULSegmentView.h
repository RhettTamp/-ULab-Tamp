//
//  ULSegmentView.h
//  U-Lab
//
//  Created by 周维康 on 17/5/22.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULView.h"
@class ULSegmentView;
@protocol ULSegmentViewDelegate <NSObject>

@required

- (void)segView:(ULSegmentView *)segmentView didSelectedIndex:(NSUInteger)index;

@end
@interface ULSegmentView : ULView

- (instancetype)initWithItems:(NSArray *)items viewArray:(NSArray *)viewArray;
- (void)selectIndex:(NSInteger)index;
@property (nonatomic, strong) RACSubject *subject;  /**< 选中某一栏的信号 */
@property (nonatomic, weak) id <ULSegmentViewDelegate> delegate;

@end
