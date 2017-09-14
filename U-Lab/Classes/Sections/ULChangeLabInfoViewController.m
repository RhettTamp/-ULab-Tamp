//
//  ULChangeLabInfoViewController.m
//  ULab
//
//  Created by 谭培 on 2017/7/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULChangeLabInfoViewController.h"
#import "ULLabInfoChangeView.h"

@interface ULChangeLabInfoViewController ()

@property (nonatomic, strong) ULLabInfoChangeView *changeInfoView;

@end

@implementation ULChangeLabInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)ul_bindViewModel{
    @weakify(self)
    [self.changeInfoView.subject subscribeNext:^(id x) {
        @ strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)ul_addSubviews{
    [self.view addSubview:self.changeInfoView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints{
    [self.changeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (ULLabInfoChangeView *)changeInfoView{
    if (!_changeInfoView) {
        _changeInfoView = [[ULLabInfoChangeView alloc]init];
    }
    return _changeInfoView;
}


@end
