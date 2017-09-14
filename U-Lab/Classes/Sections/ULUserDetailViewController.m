//
//  ULUserDetailViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/29.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULUserDetailViewController.h"
#import "ULLoginViewController.h"
#import "ULUserDetailView.h"
#import "ULUserDetailImproveViewController.h"
#import "ULUserImproveViewController.h"
#import "ULNavigationController.h"
#import "ZWKAlertView.h"
#import "ULUserChangePhoneViewController.h"
#import "ULUserDetailViewModel.h"
@interface ULUserDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZWKAlertViewDelegate>
@property (nonatomic, strong) ULUserDetailView *detailView;  /**< 详情列表 */
@property (nonatomic, strong) UIImagePickerController *imagePickerController;  /**< <#comment#> */
@property (nonatomic, strong) ZWKAlertView *selectAlertView;  /**< <#comment#> */
@property (nonatomic, strong) ULUserDetailViewModel *viewModel;  /**< <#comment#> */
@end

@implementation ULUserDetailViewController
{
    BOOL _isEditing;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isEditing = NO;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"refreshUserDetailView" object:nil];
}

- (void)refreshView{
    [self.detailView reloadData];
}

- (void)ul_layoutNavigation
{
    self.title = @"我的资料";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 17);
    if (_isEditing)
    {
        self.detailView.researchText.userInteractionEnabled = YES;
        self.detailView.schoolText.userInteractionEnabled = YES;
        [addButton setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        self.detailView.researchText.userInteractionEnabled = NO;
        self.detailView.schoolText.userInteractionEnabled = NO;
        [addButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    self.viewModel = [[ULUserDetailViewModel alloc] init];
    //    addButton.titleLabel.font = kFont(kStandardPx(28));
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        _isEditing = !_isEditing;
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if (_isEditing)
        {
            self.detailView.researchText.userInteractionEnabled = YES;
            self.detailView.schoolText.userInteractionEnabled = YES;
            [addButton setTitle:@"完成" forState:UIControlStateNormal];
        } else {
            [self.viewModel.researchCommand execute:@{
                                                     @"researchDirection" : self.detailView.researchText.text,
                                                     @"educationalHistory" : self.detailView.schoolText.text
                                                     }];
            self.detailView.researchText.userInteractionEnabled = NO;
            self.detailView.schoolText.userInteractionEnabled = NO;
            [ULUserMgr sharedMgr].school = self.detailView.schoolText.text;
            [ULUserMgr sharedMgr].research = self.detailView.researchText.text;
            [addButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem;

}

- (void)ul_bindViewModel
{
    [self.detailView.improveSubject subscribeNext:^(id x) {
        [self.selectAlertView show];
    }];
    [self.detailView.changeSubject subscribeNext:^(id x) {
        ULUserChangePhoneViewController *changeVC = [[ULUserChangePhoneViewController alloc] initWithType:x];
//        changeVC.block = ^(NSString *email) {
//            self.detailView.detailArray[2] = email;
//        };
        [self.navigationController pushViewController:changeVC animated:YES];
    }];
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_session"] forHTTPHeaderField:@"Cookie"];
    [manager POST:@"http://47.92.133.141/ulab_user/users/headImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(selectImage, 0.0001);
        [formData appendPartWithFileData:imageData name:@"headImage" fileName:[NSString stringWithFormat:@"headImage.png"] mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *imageData = UIImageJPEGRepresentation(selectImage, 0.0001);
        [JMSGUser updateMyInfoWithParameter:imageData userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        [ULUserMgr sharedMgr].avaterImage = selectImage;
        [ULUserMgr saveMgr];
        self.detailView.headerImageView.image = selectImage;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserAvatorImageDidChange object:nil userInfo:nil];
        [ULProgressHUD showWithMsg:@"头像保存成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [ULProgressHUD showWithMsg:@"头像保存失败"];
    }];
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
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
    [self.view addSubview:self.detailView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
- (ULUserDetailView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[ULUserDetailView alloc] init];
    }
    return _detailView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
