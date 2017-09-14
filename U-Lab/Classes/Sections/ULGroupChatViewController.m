//
//  ULGroupChatViewController.m
//  ULab
//
//  Created by 周维康 on 2017/6/21.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import "ULGroupChatViewController.h"
#import "ULGroupDetailViewController.h"
#import "JSQMessages.h"


@interface ULGroupChatViewController ()
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageView;  /**< 自己聊天气泡 */
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageView;  /**< 他人的消息旗袍 */
@property (nonatomic, strong) NSMutableArray<JSQMessage *> *messages;  /**< 消息数组 */
@property (nonatomic, strong) JMSGConversation *conversation;  /**< 会话 */
@property (nonatomic, strong) NSString *gid;  /**< 聊天对象 */
@end

@implementation ULGroupChatViewController

- (instancetype)initWithGroupId:(NSString *)gid conversation:(JMSGConversation *)conversation
{
    if (self = [super init])
    {
        self.gid = gid;
        self.conversation = conversation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBar];
    self.view.backgroundColor = kBackgroundColor;
    self.collectionView.backgroundColor = kBackgroundColor;
    self.messages = [NSMutableArray array];
    NSArray *messageArray = [self.conversation messageArrayFromNewestWithOffset:nil limit:@50] ;
    for (JMSGMessage *message in messageArray)
    {
        JMSGAbstractContent *content = message.content;
        if (message.contentType == kJMSGContentTypeText) {
            JMSGTextContent *textContent = (JMSGTextContent *)content;
            JSQMessage *sendMessage = [[JSQMessage alloc] initWithSenderId:message.fromUser.username senderDisplayName:@"" date:[NSDate dateWithTimeIntervalSince1970:[message.timestamp doubleValue]/1000] text:textContent.text];
            [self.messages insertObject:sendMessage atIndex:0];
            
            
        }
    }
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(40, 40);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.incomingBubbleImageView = [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:[UIImage imageNamed:@"message_otherBubble"] highlightedImage:[UIImage imageNamed:@"message_otherBubble"]];
    self.outgoingBubbleImageView = [[JSQMessagesBubbleImage alloc] initWithMessageBubbleImage:[UIImage imageNamed:@"message_myBubble"] highlightedImage:[UIImage imageNamed:@"message_myBubble"]];
    [self setupBubble];
    [self addObserve];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setNavigationBar
{
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addButton.rac_command = self.labView.viewModel.addCommand;
    detailButton.frame = CGRectMake(0, 0, 18, 17);
    @weakify(self)
    [[detailButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ULGroupDetailViewController *creatVC = [[ULGroupDetailViewController alloc] initWithGroupId:self.gid];
        [self.navigationController pushViewController:creatVC animated:YES];
    }];
    [detailButton setBackgroundImage:[UIImage imageNamed:@"message_userDetail"] forState:UIControlStateNormal];
    //    [addButton setTitle:@"新建" forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)addObserve
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFriendMessageNotification:) name:kReceiveFriendMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFriendMessageNotification:) name:kSendFriendMessageNotification object:nil];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messages[indexPath.item];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (void)setupBubble
{
    
    
}
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageView;
    }
    
    return self.incomingBubbleImageView;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    } else {
        JSQMessagesAvatarImage *image = [JSQMessagesAvatarImage avatarWithImage:[UIImage imageWithColor:kCommonGrayColor]];
        return image;
    }
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    [self.conversation sendTextMessage:text];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        JSQMessage *sendMessage = [[JSQMessage alloc] initWithSenderId:[ULUserMgr sharedMgr].userPhone senderDisplayName:@"" date:[NSDate date] text:[NSString stringWithFormat:@"%@(未发送)", text]];
        [self.messages addObject:sendMessage];
        [self finishSendingMessage];
        return;
    }
    JSQMessage *sendMessage = [[JSQMessage alloc] initWithSenderId:[ULUserMgr sharedMgr].userPhone senderDisplayName:@"" date:[NSDate date] text:text];
    [self.messages addObject:sendMessage];
    [self finishSendingMessage];
}
//- (void)addMessage:(NSString *)text senderId:(NSString *)senderId
//{
//    JSQMessage *message = [JSQMessage messageWithSenderId:senderId displayName:senderId text:text];
//    [self.messages addObject:message];
//}

- (void)receiveFriendMessageNotification:(NSNotification *)notification
{
    if ([notification.object[@"error"] isEqual:@0])
    {
        JMSGMessage *message = notification.object[@"message"];
        message.fromName = message.fromUser.username;
        JMSGAbstractContent *content = message.content;
        JMSGTextContent *textContent = (JMSGTextContent *)content;
        
        JSQMessage *receiveMessage = [[JSQMessage alloc] initWithSenderId:message.fromUser.username senderDisplayName:@"" date:[NSDate dateWithTimeIntervalSince1970:[message.timestamp doubleValue]/1000] text:textContent.text];
        [self.messages addObject:receiveMessage];
        [self finishReceivingMessage];
    }
}

- (void)sendFriendMessageNotification:(NSNotification *)notification
{
    if ([notification.object[@"error"]  isEqual: @0])
    {
        //        JMSGMessage *message = notification.object[@"message"];
        //        JMSGAbstractContent *content = message.content;
        //        JMSGTextContent *textContent = (JMSGTextContent *)content;
        //        JSQMessage *sendMessage = [[JSQMessage alloc] initWithSenderId:message.fromUser.username senderDisplayName:@"" date:[NSDate dateWithTimeIntervalSince1970:[message.timestamp doubleValue]/1000] text:textContent.text];
        //        [self.messages addObject:sendMessage];
        //
    } else {
        JMSGMessage *message = notification.object[@"message"];
        JMSGAbstractContent *content = message.content;
        JMSGTextContent *textContent = (JMSGTextContent *)content;
        JSQMessage *sendMessage = [[JSQMessage alloc] initWithSenderId:message.fromUser.username senderDisplayName:@"" date:[NSDate dateWithTimeIntervalSince1970:[message.timestamp doubleValue]/1000] text:[NSString stringWithFormat:@"%@(未发送)", textContent.text]];
        [self.messages addObject:sendMessage];
    }
    [self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = kCommonWhiteColor;
        }
        else {
            cell.textView.textColor = kTextBlackColor;
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    
    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return ([message isMediaMessage]);
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items




#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}


@end
