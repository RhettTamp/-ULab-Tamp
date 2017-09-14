//
//  ULMainShareViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/13.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMainShareViewController.h"
#import "ULMainShareStatusViewController.h"
#import "ULLabObjectViewModel.h"
#import "YYTextView.h"
#import "ZWKAlertView.h"
#import "ULLabModel.h"

@interface ULMainShareViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZWKAlertViewDelegate>

@property (nonatomic, strong) UIView *imageView;  /**< 图片 */
@property (nonatomic, strong) UIImageView *picImageView;  /**< <#comment#> */
@property (nonatomic, strong) UITableView *tableView;  /**< 详情列表 */
@property (nonatomic, strong) UIButton *useButton;  /**< 使用按钮 */
@property (nonatomic, strong) UIImageView *bottomView;  /**< 底部花篮 */
@property (nonatomic, strong) UIScrollView *scrollView;  /**< 滑动背景板 */
@property (nonatomic, strong) UILabel *label;  /**< beizhu */
@property (nonatomic, strong) YYTextView *textView;  /**< beizhu */
@property (nonatomic, assign) ULShareObjectType shareType;  /**< type  */
@property (nonatomic, strong) UIImage *picImage;  /**< <#comment#> */
@property (nonatomic, strong) NSString *numString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *adminString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *phoneString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *locationString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *nameString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *quatityString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *danweiString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *guigeString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *priceString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *factoryString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *delarString;  /**< <#comment#> */
@property (nonatomic, strong) NSString *afterString;  /**< <#comment#> */
@property (nonatomic, strong) NSDictionary *dic;  /**< <#comment#> */
@property (nonatomic, strong) NSString *beizhu;  /**< <#comment#> */
@property (nonatomic, strong) ULLabObjectViewModel *viewModel;  /**< VM */
@property (nonatomic, strong) UIImagePickerController *imagePickerController;  /**< <#comment#> */
@property (nonatomic, strong) ZWKAlertView *selectAlertView;  /**< <#comment#> */
//@property (nonatomic, strong) ULUserObjectModel *objectModel;  /**< model */

@end

@implementation ULMainShareViewController
{
//    NSArray *_detailArray;
    NSMutableArray *_inputArray;
    NSArray *_titleArray;
}

- (instancetype)initWithShareType:(ULShareObjectType)shareType
{
    self.shareType = shareType;
    self = [super init];
    return self;
}

- (void)ul_layoutNavigation
{
    switch (_shareType) {
        case ULShareObjectTypeMaterial:
            self.title = @"耗材共享";
            break;
        case ULShareObjectTypeReagent:
            self.title = @"试剂共享";
            break;
        case ULShareObjectTypeAnimal:
            self.title = @"动物共享";
            break;
        case ULShareObjectTypeLab:
            self.title = @"仪器共享";
            break;
        default:
            self.title = @"其他共享";
            break;
    }
}
- (void)ul_addSubviews
{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.modalPresentationStyle = UIModalPresentationCustom;
    [self.imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ulab_navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.imagePickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.selectAlertView = [[ZWKAlertView alloc] initWithFuncArray:@[@"从相册中选择", @"拍照"]];
    self.selectAlertView.delegate = self;
    self.dic = @{
                 @"isShare" : @1,
                 @"users" : @[],
                 @"labs" : @[],
                 @"groups" : @[]
                 };
    self.viewModel = [[ULLabObjectViewModel alloc] init];
    self.numString = @""; self.adminString = @""; self.phoneString = @""; self.locationString = @""; self.nameString = @""; self.quatityString = @""; self.danweiString = @""; self.guigeString = @""; self.priceString = @""; self.factoryString = @""; self.delarString = @""; self.afterString = @"";
    _inputArray = [NSMutableArray arrayWithObject:@[self.numString, self.adminString, self.phoneString, self.locationString, self.nameString, self.quatityString, self.danweiString, self.guigeString, self.priceString, self.factoryString, self.delarString, self.afterString]];

        switch (_shareType) {
        case ULShareObjectTypeMaterial:
            _titleArray = @[@"编号", @"联系方式", @"位置", @"名称", @"数量", @"单位", @"规格", @"单价金额", @"厂家", @"经销商", @"售后电话", @"共享状态"];
            break;
        case ULShareObjectTypeReagent:
            _titleArray = @[@"编号", @"联系方式", @"位置", @"名称", @"数量", @"单位", @"规格", @"单价金额", @"厂家", @"经销商", @"售后电话", @"共享状态"];
            break;
            case ULShareObjectTypeAnimal:{
                _titleArray = @[@"编号", @"联系方式", @"位置", @"名称", @"雄性数量", @"雌性数量", @"出生日期", @"品系",  @"单价金额", @"来源",  @"经销商", @"售后电话", @"共享状态"];
                _inputArray = [NSMutableArray arrayWithObject:@[self.numString, self.adminString, self.phoneString, self.locationString, self.nameString, self.quatityString, self.danweiString, self.guigeString, self.priceString, self.factoryString, self.delarString, self.afterString, @""]];}
                break;
        case ULShareObjectTypeLab:
                _titleArray = @[@"编号", @"联系方式", @"位置", @"名称", @"数量", @"单位", @"型号", @"单价金额", @"厂家", @"经销商", @"售后电话", @"共享状态"];
            break;
        default:
                _titleArray = @[@"编号", @"联系方式", @"位置", @"名称", @"数量", @"单位", @"规格", @"单价金额", @"厂家", @"经销商", @"售后电话", @"共享状态"];
            break;
    }

    //    _detailArray = @[@(self.objectModel.labId), self.objectModel.ownerName, self.objectModel.contactNumber, self.objectModel.objectLocation, self.objectModel.objectName, @(self.objectModel.objectQuantity), self.objectModel.measureUnit, self.objectModel.specification, @(self.objectModel.price), self.objectModel.factory, self.objectModel.dealer, self.objectModel.servicePhone, share];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.useButton];
    [self.scrollView addSubview:self.label];
    [self.scrollView addSubview:self.textView];
    [self.view addSubview:self.bottomView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}
- (void)ul_bindViewModel

{
    [self.viewModel.inCommand.executionSignals.flatten subscribeNext:^(id x) {
        [ULProgressHUD showWithMsg:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateViewConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+18);
        make.height.mas_equalTo(screenHeight-64-33-18);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.scrollView);
        make.height.mas_offset(88);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom);
        make.height.mas_equalTo(_titleArray.count*45);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120);
        make.top.equalTo(self.label.mas_bottom).offset(8);
    }];
    [self.useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(54);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    [super updateViewConstraints];
}
- (UIView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIView alloc] init];
        _imageView.backgroundColor = kCommonWhiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.text = @"图片：";
        label.font = kFont(kStandardPx(30));
        label.textColor = KTextGrayColor;
        [_imageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView).offset(15);
            make.centerY.equalTo(_imageView);
        }];
        self.picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ulab_object_default"]];
        [_imageView addSubview:self.picImageView];
        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_imageView.mas_right).offset(-15);
            make.centerY.equalTo(_imageView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kBackgroundColor;
        [_imageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_imageView);
            make.height.mas_equalTo(0.5);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertView)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)showAlertView
{
    [self.selectAlertView show];
}
- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(screenWidth, _titleArray.count*45+88+164+140);
        _scrollView.backgroundColor = kBackgroundColor;
        _scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _scrollView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ULLabObjectDetailTableViewCellIdentifier"];
    }
    return _tableView;
}
- (void)alertView:(ZWKAlertView *)alertView didClickAtIndex:(NSInteger)index
{
    [alertView hide];
    
    if (index == 0)
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(index == 1) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectImage = info[UIImagePickerControllerEditedImage];
    self.picImageView.image = selectImage;
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_bottom"]];
    }
    return _bottomView;
}

- (UIButton *)useButton
{
    if (!_useButton)
    {
        _useButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.backgroundColor = KButtonBlueColor;
        [_useButton setTitle:@"共享" forState:UIControlStateNormal];
        [_useButton setTitleColor:kCommonWhiteColor forState:UIControlStateNormal];
        [[_useButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            __block BOOL shouldStop = NO;
            [_inputArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj  isEqual: @""])
                {
                    [ULProgressHUD showWithMsg:[NSString stringWithFormat:@"请填写%@", _titleArray[idx]]];
                    *stop = YES;
                    shouldStop = YES;
                    return;
                }
            }];
            @weakify(self)
            if (!shouldStop)
            {
            [ULProgressHUD showWithMsg:@"添加共享中" inView:self.view withBlock:^{
                @strongify(self)
                switch (self.shareType) {
                    case ULShareObjectTypeAnimal:
                        switch ([self.dic[@"isShare"] integerValue]) {
                            case 0: {
                                [self.viewModel.inCommand execute:@{
                            
                                                                    
                                                   @"itemId":_inputArray[0],
                                                   @"isShared":@(0), //是否共享
                                                   @"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":[NSString stringWithFormat:@"%@/%@", _inputArray[4], _inputArray[5]],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[8] integerValue]),
                                                                    @"unitMeasurement":@"只",
                                                                    @"factory":_inputArray[8],
                                                                    @"specification":@"",
                                                                    @"dealer":_inputArray[9],
                                                                    @"afterServicePhone":_inputArray[11],
                                                                    @"description":_textView.text,
                                                   
                                                                    
                                                                    }];
                            }
                                
                                break;
                            case 1:{
                                [self.viewModel.inCommand execute:@{
                                                                    @"itemId":_inputArray[0],
                                                                    @"isShared":_dic[@"isShare"], //是否共享
                                                                    @"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":[NSString stringWithFormat:@"%@/%@", _inputArray[4], _inputArray[5]],
                                                                    @"location":_inputArray[3],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[8] integerValue]),
                                                                    @"unitMeasurement":@"只",
                                                                    @"factory":_inputArray[9],
                                                                    @"specification":@"",
                                                                    @"dealer":_inputArray[10],
                                                                    @"afterServicePhone":_inputArray[11],
                                                                    @"description":_textView.text,
                                                                    }];
                            }
                                break;
                            case 2:{
                                NSMutableString *labString = [NSMutableString string];
                                NSArray *labArray = self.dic[@"labs"];
                                for (NSInteger i=0; i<labArray.count; i++)
                                {
                                    ULLabModel *model = labArray[i];
                                    if (i == labArray.count-1)
                                    {
                                        [labString appendString:[NSString stringWithFormat:@"%lu",model.labID]];
                                    } else {
                                        [labString appendString:[NSString stringWithFormat:@"%lu,",model.labID]];
                                    }
                                }
                                NSMutableString *userString = [NSMutableString string];
                                NSArray *userArray = self.dic[@"users"];
                                for (NSInteger i=0; i<userArray.count; i++)
                                {
                                    JMSGUser *user = userArray[i];
                                    if (i == userArray.count-1)
                                    {
                                        [userString appendString:[NSString stringWithFormat:@"%@",user.region]];
                                    } else {
                                        [userString appendString:[NSString stringWithFormat:@"%@,",user.region]];
                                    }
                                }

                                [self.viewModel.inCommand execute:@{
                                                               
                                                                    @"itemId":_inputArray[0],
                                                                    @"isShared":_dic[@"isShare"], //是否共享@"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":[NSString stringWithFormat:@"%@/%@", _inputArray[4], _inputArray[5]],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[8] integerValue]),
                                                                    @"unitMeasurement":@"只",
                                                                    @"factory":_inputArray[9],
                                                                    @"specification":@"",
                                                                    @"dealer":_inputArray[10],
                                                                    @"afterServicePhone":_inputArray[11],
                                                                    @"description":_textView.text,
                                                                    
                                                                    //以下参数isShared为true的时候才有
                                                                    @"userIds":userString, //共享的用户id
                                                                    @"labIds":labString, //共享的实验室id
                                                                    }];
                            }
                                break;
                            default:{
                                [self.viewModel.inCommand execute:@{
                                                                   
                                                                    @"itemId":_inputArray[0],
                                                                    @"isShared":_dic[@"isShare"], //是否共享@"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":[NSString stringWithFormat:@"%@/%@", _inputArray[4], _inputArray[5]],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[8] integerValue]),
                                                                    @"unitMeasurement":@"只",
                                                                    @"factory":_inputArray[9],
                                                                    @"specification":@"",
                                                                    @"dealer":_inputArray[10],
                                                                    @"afterServicePhone":_inputArray[11],
                                                                    @"description":_textView.text,
                    
                                                                    }];

                            }
                                break;
                        }
                        
                        break;
                        
                    default:{
                        switch ([self.dic[@"isShare"] integerValue]) {
                            case 0: {
                                [self.viewModel.inCommand execute:@{
                                                                    @"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":_inputArray[4],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[7] integerValue]),
                                                                    @"unitMeasurement":_inputArray[5],
                                                                    @"factory":_inputArray[8],
                                                                    @"specification":_inputArray[6],
                                                                    @"dealer":_inputArray[9],
                                                                    @"afterServicePhone":_inputArray[10],
                                                                    @"description":_textView.text,
                                                                    @"isShared":@0 //是否共享
                                                                  
                                                                    }];}
                                
                                break;
                            case 1:{
                                [self.viewModel.inCommand execute:@{
                                                                    @"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":_inputArray[4],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[7] integerValue]),
                                                                    @"unitMeasurement":_inputArray[5],
                                                                    @"factory":_inputArray[8],
                                                                    @"specification":_inputArray[6],
                                                                    @"dealer":_inputArray[9],
                                                                    @"afterServicePhone":_inputArray[10],
                                                                    @"description":_textView.text,
                                                                    @"isShared":@1 //是否共享
                                                         
                                                                    }];
                            }
                                break;
                            case 2:{
                                NSMutableString *labString = [NSMutableString string];
                                NSArray *labArray = self.dic[@"labs"];
                                for (NSInteger i=0; i<labArray.count; i++)
                                {
                                    ULLabModel *model = labArray[i];
                                    if (i == labArray.count-1)
                                    {
                                        [labString appendString:[NSString stringWithFormat:@"%lu",model.labID]];
                                    } else {
                                        [labString appendString:[NSString stringWithFormat:@"%lu,",model.labID]];
                                    }
                                }
                                NSMutableString *userString = [NSMutableString string];
                                NSArray *userArray = self.dic[@"users"];
                                for (NSInteger i=0; i<userArray.count; i++)
                                {
                                    JMSGUser *user = userArray[i];
                                    if (i == userArray.count-1)
                                    {
                                        [userString appendString:[NSString stringWithFormat:@"%@",user.region]];
                                    } else {
                                        [userString appendString:[NSString stringWithFormat:@"%@,",user.region]];
                                    }
                                }
                                
                                [self.viewModel.inCommand execute:@{
                                                                    @"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":_inputArray[4],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[7] integerValue]),
                                                                    @"unitMeasurement":_inputArray[5],
                                                                    @"factory":_inputArray[8],
                                                                    @"specification":_inputArray[6],
                                                                    @"dealer":_inputArray[9],
                                                                    @"afterServicePhone":_inputArray[10],
                                                                    @"description":_textView.text,
                                                                    @"isShared":@2, //是否共享
                                                                    //以下参数isShared为true的时候才有
                                                                    @"userIds":userString, //共享的用户id
                                                                    @"labIds":labString //共享的实验室id
                                             
                                                                    }];
                            }
                                break;
                            default:{
                                [self.viewModel.inCommand execute:@{
                                                                    @"itemImage" : self.picImageView.image,
                                                                    @"name":_inputArray[3],
                                                                    @"type":@(self.shareType), //(1耗材 2试剂 3动物 4仪器)
                                                                    @"quantity":_inputArray[4],
                                                                    @"location":_inputArray[2],
                                                                    @"contactNumber":@([_inputArray[1] integerValue]),
                                                                    @"unitPrice":@([_inputArray[7] integerValue]),
                                                                    @"unitMeasurement":_inputArray[5],
                                                                    @"factory":_inputArray[8],
                                                                    @"specification":_inputArray[6],
                                                                    @"dealer":_inputArray[9],
                                                                    @"afterServicePhone":_inputArray[10],
                                                                    @"description":_textView.text,
                                                                    @"isShared":@1, //是否共享
                                                             
                                                                    }];
                            }
                                break;
                        }
                        
                    }
                        
                        break;
                }

            }];
            }
        }];
    }
    return _useButton;
}

- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
        _label.text = @"备注";
        _label.textColor = KTextGrayColor;
        _label.font = kFont(kStandardPx(24));
    }
    return _label;
}

- (YYTextView *)textView
{
    if (!_textView)
    {
        _textView = [[YYTextView alloc] init];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 15, 0, -15);
        _textView.font = kFont(kStandardPx(28));
        _textView.backgroundColor = kCommonWhiteColor;
        _textView.placeholderText = @"(选填)";
        [self setTextFieldInputAccessoryView:nil];
    }
    return _textView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ULLabObjectDetailTableViewCellIdentifier"];
    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }
    cell.backgroundColor = kCommonWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [NSString stringWithFormat:@"%@：",_titleArray[indexPath.row]];
    nameLabel.textColor = kTextBlackColor;
    nameLabel.font = kFont(kStandardPx(28));
    [cell addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(15);
        make.centerY.equalTo(cell);
    }];
    if (indexPath.row == _titleArray.count-1)
    {
        UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_user_next"]];
        [cell addSubview:next];
        [next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-20);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    } else {
        UITextField *textField = [[UITextField alloc] init];
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = [NSString stringWithFormat:@"请填写%@", _titleArray[indexPath.row]];
        if ((indexPath.row == 5||indexPath.row == 11) && self.shareType != ULShareObjectTypeAnimal )
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else if ((indexPath.row == 5|| indexPath.row == 6||indexPath.row == 9||indexPath.row==12) && self.shareType == ULShareObjectTypeAnimal )
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [self setTextFieldInputAccessoryView:textField];
        textField.font = kFont(kStandardPx(28));
        textField.textColor = kTextBlackColor;
        [[textField rac_textSignal] subscribeNext:^(id x) {
            _inputArray[indexPath.row] = x;
        }];
        [cell addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-15);
            make.centerY.equalTo(cell);
        }];
    }
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kBackgroundColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _titleArray.count-1)
    {
        ULMainShareStatusViewController *statusVC = [[ULMainShareStatusViewController alloc] init];
        [statusVC.popSubject subscribeNext:^(id x) {
            self.dic = x;
        }];
        [self.navigationController pushViewController:statusVC animated:YES];
    }
}
- (void)setTextFieldInputAccessoryView:(UITextField *)textField{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * spaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(2, 5, 40, 45);
    [doneBtn addTarget:self action:@selector(dealKeyboardHide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceBtn,doneBtnItem,nil];
    [topView setItems:buttonsArray];
    if (textField)
    {
        [textField setInputAccessoryView:topView];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    } else {
        [self.textView setInputAccessoryView:topView];
        [self.textView setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
}

- (void)dealKeyboardHide {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
