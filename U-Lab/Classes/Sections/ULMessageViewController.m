//
//  ULMessageViewController.m
//  U-Lab
//
//  Created by 周维康 on 17/5/18.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULMessageViewController.h"
#import "ULMessageFriendSearchViewController.h"
#import "ULGroupCreatViewController.h"
#import "ULMessageView.h"
#import "ULMessageChatViewController.h"
#import "ULLendApplyViewController.h"
#import "ZWKAlertView.h"
#import "ULGroupChatViewController.h"
#import "ULBuyApplyViewController.h"
#import "ULMainObjectDetailViewController.h"


@interface ULMessageViewController () <ZWKAlertViewDelegate>

@property (nonatomic, strong) ULMessageView *messageView;  /**< 消息视图 */
@property (nonatomic, strong) ZWKAlertView *alertView;  /**< alert */

@end

@implementation ULMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)ul_bindViewModel
{
    [self.messageView.friendView.chatSubject subscribeNext:^(id x) {
        @weakify(self)
        if ([x[@"type"]  isEqual: @0])
        {
            JMSGUser *user = x[@"next"];
            [JMSGConversation createSingleConversationWithUsername:user.username completionHandler:^(id resultObject, NSError *error) {
                @strongify(self)
                ULMessageChatViewController *chatVC = [[ULMessageChatViewController alloc] initWithUser:user conversation:resultObject];
                chatVC.title = user.nickname;
                NSString *senderId;
                if ([ULUserMgr sharedMgr].regType == 0) {
                    senderId = [ULUserMgr sharedMgr].userPhone;
                }else{
                    senderId = [ULUserMgr sharedMgr].userEmail;
                }

                chatVC.senderId = [senderId copy];
                chatVC.senderDisplayName = @"";
                [self.navigationController pushViewController:chatVC animated:YES];
            }];
        } else {
            [JMSGConversation createGroupConversationWithGroupId:[NSString stringWithFormat:@"%@", x[@"next"]] completionHandler:^(id resultObject, NSError *error) {
                @strongify(self)
                ULGroupChatViewController *chatVC = [[ULGroupChatViewController alloc] initWithGroupId:[NSString stringWithFormat:@"%@", x[@"next"]] conversation:resultObject];
                [JMSGGroup groupInfoWithGroupId:[NSString stringWithFormat:@"%@", x[@"next"]] completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        JMSGGroup *group = (JMSGGroup *)resultObject;
                        chatVC.title = group.name;
                    }
                }];
                chatVC.senderId = [ULUserMgr sharedMgr].userPhone;
                chatVC.senderDisplayName = @"";
                [self.navigationController pushViewController:chatVC animated:YES];            }];
        }
    }];
    [self.messageView.orderView.nextSubject subscribeNext:^(id x) {
        if ([x[@"type"] isEqual:@0]) {
            ULLendApplyViewController *lendVC = [[ULLendApplyViewController alloc] initWithModel:x[@"response"] andType:@1];
            [self.navigationController pushViewController:lendVC animated:YES];
        }else if ([x[@"type"] isEqual:@1]){
            ULMainObjectDetailViewController *vc = [[ULMainObjectDetailViewController alloc]initWithObjectModel:x[@"response"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ULBuyApplyViewController *buyVC = [[ULBuyApplyViewController alloc] initWithModel:x[@"response"]];
            [self.navigationController pushViewController:buyVC animated:YES];
        }

    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.messageView.appearSubject sendNext:nil];
}
- (void)ul_layoutNavigation
{
    self.title = @"消息";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addButton.rac_command = self.labView.viewModel.addCommand;
    addButton.frame = CGRectMake(0, 0, 18, 17);
    @weakify(self)
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.alertView show];
    }];
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_user_add"] forState:UIControlStateNormal];
    //    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)ul_addSubviews
{
    self.alertView = [[ZWKAlertView alloc] initWithFuncArray:@[@"添加好友/群", @"创建群"]];
    self.alertView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendInvitiaonChangeNotification:)
                                                 name:kFriendInvitationNotification
                                               object:nil];
    [self.view addSubview:self.messageView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}
#pragma mark - FriendInvitationNotification
- (void)friendInvitiaonChangeNotification:(NSNotification *)notification{
    NSLog(@"Action - friendInvitiaonChangeNotification in JMSGFriendInvitationViewController");
    JMSGFriendNotificationEvent *event = (JMSGFriendNotificationEvent *)notification.object;
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
        case kJMSGEventNotificationReceiveFriendInvitation: {
            JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[ULUserMgr sharedMgr].addFriendArray addObject:[friendEvent getFromUser]];
        }
            break;
        case kJMSGEventNotificationAcceptedFriendInvitation: {
            JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[ULUserMgr sharedMgr].friendArray addObject:[friendEvent getFromUser]];
        }
            break;
        case kJMSGEventNotificationDeclinedFriendInvitation: {
            
        }
            break;
        case kJMSGEventNotificationDeletedFriend: {
            JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            [[ULUserMgr sharedMgr].friendArray removeObject:[friendEvent getFromUser]];
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate: {
            
        }
            break;
        default:
            NSLog(@"Other Notification Event ");
            break;
    }

}
- (void)updateViewConstraints
{
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)alertView:(ZWKAlertView *)alertView didClickAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        ULMessageFriendSearchViewController *creatVC = [[ULMessageFriendSearchViewController alloc] init];
        [self.navigationController pushViewController:creatVC animated:YES];
    } else {
        ULGroupCreatViewController *groupVC = [[ULGroupCreatViewController alloc] init];
        [self.navigationController pushViewController:groupVC animated:YES];
    }
    [alertView hide];
}
- (ULMessageView *)messageView
{
    if (!_messageView)
    {
        _messageView = [[ULMessageView alloc] init];
    }
    return _messageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
