//
//  ULLabMemberChangeViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/23.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULLabMemberChangeViewController.h"
#import "ULLabMemberModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ULLabMemberChangeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *memberArray;  /**< <#comment#> */
@property (nonatomic, strong) UIView *piView;  /**< <#comment#> */
@property (nonatomic, strong) UITableView *tableView;  /**< <#comment#> */
@property (nonatomic, strong) UIImageView *bottomView;  /**< <#comment#> */
@property (nonatomic, strong) ULBaseRequest *request;
@end

@implementation ULLabMemberChangeViewController
{
    ULLabMemberModel *PIModel;
    NSMutableArray *managerArray;
    NSMutableArray *commenArray;
}
- (instancetype)initWithMemberArray:(NSArray *)array
{
    self.memberArray = [array mutableCopy];
    self = [super init];
    return self;
}

- (void)ul_addSubviews
{
    self.view.backgroundColor = kBackgroundColor;
//    [self.view addSubview:self.piView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)ul_layoutNavigation
{
    self.title = @"人员管理";
    //    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addButton.frame = CGRectMake(0, 0, 40, 17);
    //    [addButton setTitle:@"编辑" forState:UIControlStateNormal];
    //
    //    //    addButton.titleLabel.font = kFont(kStandardPx(28));
    //    @weakify(self)
    //    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    //        @strongify(self)
    //        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    //        ULLabMemberChangeViewController *vc = [[ULLabMemberChangeViewController alloc] initWithMemberArray:self.memberView.memberArray];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }];
    //    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    //
    //    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)updateViewConstraints
{
//    [self.piView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view).offset(18+64);
//        make.height.mas_equalTo(45);
//    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.piView.mas_bottom).offset(8);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-33);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}

- (UIView *)piView{
    if (_piView) {
        _piView = [[UIView alloc]init];
    }
    return _piView;
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 88;
        //        _fristTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabMemberChangeTableViewCellIdentifier"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.backgroundColor = kCommonWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ULLabMemberModel *model = self.memberArray[indexPath.row];
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
    headerImageView.layer.cornerRadius = 25.5;
    headerImageView.layer.masksToBounds = YES;
    [cell addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = model.memberName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(35));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(17);
        make.centerY.equalTo(cell);
    }];
    if ([[ULUserMgr sharedMgr].userId integerValue] != model.memberId) {
        if ([[ULUserMgr sharedMgr].role integerValue] == 1) {
            if ([model.role integerValue] == 0) {
                UIButton *removeButton = [UIButton new];
                [removeButton setTitle:@"移除" forState:UIControlStateNormal];
                [removeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                removeButton.tag = indexPath.row+1000;
                [removeButton addTarget:self action:@selector(removeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:removeButton];
                [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_offset(-10);
                    make.centerY.equalTo(cell);
                }];
                
            }
        }
        if ([[ULUserMgr sharedMgr].role integerValue] == 2) {
            UIButton *removeButton = [UIButton new];
            [removeButton setTitle:@"移除" forState:UIControlStateNormal];
            [removeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            removeButton.tag = indexPath.row+1000;
            [removeButton addTarget:self action:@selector(removeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:removeButton];
            [removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(-10);
                make.centerY.equalTo(cell);
            }];
            
            if ([model.role integerValue] == 1) {
                UIButton *cancelButton = [[UIButton alloc]init];
                cancelButton.tag = indexPath.row+100;
                [cancelButton setTitle:@"取消管理员" forState:UIControlStateNormal];
                [cancelButton addTarget:self action:@selector(cancelManagerClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cancelButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
                [cell addSubview:cancelButton];
                [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(removeButton.mas_left).offset(-20);
                    make.centerY.equalTo(cell);
                }];
            }else{
                UIButton *becomeButton = [[UIButton alloc]init];
                becomeButton.tag = indexPath.row+200;
                [becomeButton setTitle:@"任命管理员" forState:UIControlStateNormal];
                [becomeButton addTarget:self action:@selector(becomeManagerClicked:) forControlEvents:UIControlEventTouchUpInside];
                [becomeButton setTitleColor:kCommonBlueColor forState:UIControlStateNormal];
                [cell addSubview:becomeButton];
                [becomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(removeButton.mas_left).offset(-20);
                    make.centerY.equalTo(cell);
                }];
            }
        }
        
    }

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
    
}

- (void)cancelManagerClicked:(UIButton *)button{
    ULLabMemberModel *model = self.memberArray[button.tag-100];
    [self.request patchDataWithParameter:@{
                                           @"user_id" : @(model.memberId),
                                           @"roleId" : @0
                                           } session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                               //                                               [commenArray addObject:model];
                                               //                                               [managerArray removeObject:model];
                                               //                                               [self choiceArray];
                                               //                                               [self.tableView reloadData];
                                               [button setTitle:@"任命管理员" forState:UIControlStateNormal];
                                               [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                                               button.tag = button.tag+100;
                                               [button addTarget:self action:@selector(becomeManagerClicked:) forControlEvents:UIControlEventTouchUpInside];
                                           } failure:^(ULBaseRequest *request, NSError *error) {
                                               [ULProgressHUD showWithMsg:[NSString stringWithFormat:@"%@",error]];
                                           } withPath:@"ulab_user/users/role"];
    
}

- (void)becomeManagerClicked:(UIButton *)button{
    
    ULLabMemberModel *model = self.memberArray[button.tag-200];
    [self.request patchDataWithParameter:@{
                                           @"user_id" : @(model.memberId),
                                           @"roleId" : @1
                                           } session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                               //                                               [commenArray addObject:model];
                                               //                                               [managerArray removeObject:model];
                                               //                                               [self choiceArray];
                                               //                                               [self.tableView reloadData];
                                               [button setTitle:@"取消管理员" forState:UIControlStateNormal];
                                               [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                                               button.tag = button.tag-100;
                                               [button addTarget:self action:@selector(cancelManagerClicked:) forControlEvents:UIControlEventTouchUpInside];
                                           } failure:^(ULBaseRequest *request, NSError *error) {
                                               [ULProgressHUD showWithMsg:[NSString stringWithFormat:@"%@",error]];
                                           } withPath:@"ulab_user/users/role"];
}

- (void)removeClicked:(UIButton *)button{
    ULLabMemberModel *model = self.memberArray[button.tag-1000];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要移除该成员" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.request deleteDataWithParameter:@{
                                                    @"user_id" : @(model.memberId),
                                                    } session:YES success:^(ULBaseRequest *request, NSDictionary *responseObject) {
                                                        [self.memberArray removeObject:model];
                                                        [self.tableView reloadData];
                                                    } failure:^(ULBaseRequest *request, NSError *error) {
                                                        [ULProgressHUD showWithMsg:[NSString stringWithFormat:@"%@",error]];
                                                    } withPath:@"ulab_lab/lab/user"];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        [alert addAction:action];
        [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    view.backgroundColor = kCommonWhiteColor;
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(64);
//    }];
    UIImageView *headerImageView = [[UIImageView alloc] init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:PIModel.headImage] placeholderImage:[UIImage imageNamed:@"ulab_user_default"]];
    headerImageView.layer.cornerRadius = 25.5;
    headerImageView.layer.masksToBounds = YES;
    [view addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(15);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = PIModel.memberName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = kFont(kStandardPx(40));
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(17);
        make.centerY.equalTo(view);
    }];
    UILabel *PILabel = [[UILabel alloc]init];
    PILabel.text = @"PI";
    PILabel.textColor = [UIColor blackColor];
    PILabel.font = kFont(kStandardPx(40));
    [view addSubview:PILabel];
    [PILabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-10);
        make.centerY.equalTo(view);
    }];
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    managerArray = [NSMutableArray array];
    commenArray = [NSMutableArray array];
    [self choiceArray];
    [self.tableView reloadData];
}

- (void)choiceArray{
    for (ULLabMemberModel *model in self.memberArray) {
        if ([model.role integerValue] == 2) {
            PIModel = model;
        }else if ([model.role integerValue] == 1){
            [managerArray addObject:model];
        }else{
            [commenArray addObject:model];
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    //    [arr addObject:PIModel];
    [arr addObjectsFromArray:managerArray];
    [arr addObjectsFromArray:commenArray];
    self.memberArray = [arr mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ULBaseRequest *)request{
    if (!_request) {
        _request = [[ULBaseRequest alloc]init];
        _request.isJson = YES;
    }
    return _request;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
