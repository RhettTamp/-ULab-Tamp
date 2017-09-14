//
//  ULUserLabCreatViewController.m
//  U-Lab
//
//  Created by 周维康 on 2017/6/3.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserLabCreatViewController.h"
#import "ULUserLabCreatView.h"
#import "ULUserLabModel.h"

@interface ULUserLabCreatViewController()

@property (nonatomic, strong) ULUserLabCreatView *creatView;  /**< 创建视图 */
@property (nonatomic, strong) ULUserLabModel *model;  /**< model */
@property (nonatomic, strong) NSNumber *projectId;  /**< id */
@end

@implementation ULUserLabCreatViewController

- (void)ul_addSubviews
{
    [self.view addSubview:self.creatView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (instancetype)initWithLabModel:(ULUserLabModel *)model
{
    self.model = model;
    if (self = [super init])
    {
        
    }
    return self;
}

- (instancetype)initWithLabModel:(ULUserLabModel *)model projectId:(NSNumber *)projectId
{
    self.model = model;
    self.projectId = projectId;
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)ul_bindViewModel
{
    @weakify(self)
    [self.creatView.finishSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.popSubject sendNext:x];
        [ULProgressHUD showWithMsg:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)ul_layoutNavigation
{
    if (_isEdit)
    {
        self.title = @"编辑实验";
    } else {
        self.title = @"新建实验";
    }
}
- (void)updateViewConstraints
{
    [self.creatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (RACSubject *)popSubject
{
    if (!_popSubject)
    {
        _popSubject = [RACSubject subject];
    }
    return _popSubject;
}
- (ULUserLabCreatView *)creatView
{
    if (!_creatView)
    {
        _creatView = [[ULUserLabCreatView alloc] initWithProjectId:self.projectId labModel:self.model];
        _creatView.isEdit = _isEdit;
    }
    return _creatView;
}
@end
