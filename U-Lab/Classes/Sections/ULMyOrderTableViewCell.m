//
//  ULMyOrderTableViewCell.m
//  U-Lab
//
//  Created by 周维康 on 17/5/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMyOrderTableViewCell.h"

@interface ULMyOrderTableViewCell()

@property (nonatomic, assign) ULMyOrderLendStatus orderStatus;  /**< 订单状态  */
@property (nonatomic, strong) UIImageView *headerView;  /**< 头像 */
@property (nonatomic, strong) UILabel *nameLabel;  /**< 用户名 */
@property (nonatomic, strong) UILabel *messageLabel;  /**< 借用消息 */
@property (nonatomic, strong) UIButton *statusButton;  /**< 借用状态 */
@end
@implementation ULMyOrderTableViewCell

- (instancetype)initWithOrderStatus:(ULMyOrderLendStatus)status reuseIdentifier:(NSString *)reuseIdentifier
{
    _orderStatus = status;
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        
    }
    return self;
}

- (void)ul_setupViews
{
    [self addSubview:self.headerView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.statusButton];
}

- (void)updateConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(51, 51));
        make.left.equalTo(self).offset(15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).offset(17);
        make.top.equalTo(self.headerView);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
    }];
    [super updateConstraints];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.text = 
    }
    return _nameLabel;
}
@end
