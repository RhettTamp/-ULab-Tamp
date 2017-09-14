//
//  ULMessageView.m
//  U-Lab
//
//  Created by 周维康 on 17/5/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageView.h"
#import "ULSegmentView.h"

@interface ULMessageView()

@property (nonatomic, strong) ULSegmentView *segControl;  /**< 顶部选择栏 */


@end

@implementation ULMessageView

- (void)ul_setupViews
{
    [self addSubview:self.segControl];
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)ul_bindViewModel
{
    self.appearSubject = [RACSubject subject];
    @weakify(self)
    [self.appearSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.friendView updateFriendList];
        [self.orderView updateOrderList];
    }];
}
- (void)updateConstraints
{
    [self.segControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.height.mas_equalTo(screenHeight-64);
    }];
    [super updateConstraints];
}
- (ULMessageFriendView *)friendView
{
    if (!_friendView)
    {
        _friendView = [[ULMessageFriendView alloc] init];
    }
    return _friendView;
}

- (ULMessageOrderView *)orderView
{
    if (!_orderView)
    {
        _orderView = [[ULMessageOrderView alloc] init];
    }
    return _orderView;
}

- (ULSegmentView *)segControl
{
    if (!_segControl)
    {
        _segControl = [[ULSegmentView alloc] initWithItems:@[@"订单消息", @"好友消息"] viewArray:@[self.orderView, self.friendView]];
    }
    return _segControl;
}


@end
