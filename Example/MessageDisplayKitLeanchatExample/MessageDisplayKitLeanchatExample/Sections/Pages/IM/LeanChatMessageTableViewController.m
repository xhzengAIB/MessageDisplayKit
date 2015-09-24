//
//  LeanChatMessageTableViewController.m
//  MessageDisplayKitLeanchatExample
//
//  Created by Jack_iMac on 15/3/21.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "LeanChatMessageTableViewController.h"
#import <MessageDisplayKit/XHDisplayTextViewController.h>
#import <MessageDisplayKit/XHDisplayMediaViewController.h>
#import <MessageDisplayKit/XHDisplayLocationViewController.h>

#import <MessageDisplayKit/XHAudioPlayerHelper.h>

// IM
#import "LeanChatManager.h"

static NSInteger const kOnePageSize = 7;

@interface LeanChatMessageTableViewController () <XHAudioPlayerHelperDelegate>

@property (nonatomic, strong) NSArray *emotionManagers;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;

@property (nonatomic, strong) AVIMConversation *conversation;

@property (nonatomic, strong) NSArray *clientIDs;

@property (nonatomic, assign) ConversationType conversationType;

@end

@implementation LeanChatMessageTableViewController

- (instancetype)initWithClientIDs:(NSArray *)clientIDs {
    self = [super init];
    if (self) {
        self.clientIDs = clientIDs;
        if (self.clientIDs.count > 1) {
            self.conversationType = ConversationTypeGroup;
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (CURRENT_SYS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    }
    self.title = NSLocalizedStringFromTable(@"Chat", @"MessageDisplayKitString", @"聊天");
    
    // Custom UI
//    self.loadMoreActivityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundImage:[UIImage imageNamed:@"TableViewBackgroundImage"]];
    
    // 设置自身用户名
    self.messageSender = [self displayNameByClientId:[[LeanChatManager manager] selfClientID]];
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video",@"sharemore_location", @"sharemore_videovoip", @"sharemore_friendcard", @"sharemore_myfav", @"sharemore_wxtalk", @"sharemore_voiceinput", @"sharemore_openapi", @"sharemore_openapi", @"Avatar"];
    NSArray *plugTitle = @[@"照片", @"拍摄",@"位置",@"视频",@"名片", @"我的收藏", @"实时对讲机", @"语音输入", @"大众点评", @"应用", @"曾宪华"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < 18; j ++) {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld",(long)(j%16)] ofType:@"gif"];
            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
            [emotions addObject:emotion];
        }
        emotionManager.emotions = emotions;
        [emotionManagers addObject:emotionManager];
    }
    
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    // 创建一个对话
    self.loadingMoreMessage = YES;
    WEAKSELF
    [[LeanChatManager manager] createConversationsWithClientIDs:self.clientIDs conversationType:self.conversationType completion:^(BOOL succeeded, AVIMConversation *createConversation) {
        if (succeeded) {
            weakSelf.conversation = createConversation;
            [weakSelf.conversation queryMessagesWithLimit:kOnePageSize callback:^(NSArray *queryMessages, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *typedMessages = [self filterTypedMessage:queryMessages];
                    NSMutableArray *messages = [NSMutableArray array];
                    for (AVIMTypedMessage *typedMessage in typedMessages) {
                        XHMessage *message = [weakSelf displayMessageByAVIMTypedMessage:typedMessage];
                        if (message) {
                            [messages addObject:message];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.messages = messages;
                        [weakSelf.messageTableView reloadData];
                        [weakSelf scrollToBottomAnimated:NO];
                        //延迟，以避免上面的滚动触发上拉加载消息
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            weakSelf.loadingMoreMessage = NO;
                        });
                    });
                });
            }];
        }
    }];
}

// 这里也要把 setupDidReceiveTypedMessageCompletion 放到 viewDidAppear 中
// 不然, 就会冲突, 导致不能实时接收到对方的消息
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF
    [[LeanChatManager manager] setupDidReceiveTypedMessageCompletion:^(AVIMConversation *conversation, AVIMTypedMessage *message) {
        // 富文本信息
        if([conversation.conversationId isEqualToString:self.conversation.conversationId]){
            [weakSelf insertAVIMTypedMessage:message];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[LeanChatManager manager] setupDidReceiveTypedMessageCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    [[LeanChatManager manager] setupDidReceiveTypedMessageCompletion:nil];
}

#pragma mark - LearnChat Message Handle Method

- (NSMutableArray *)filterTypedMessage:(NSArray *)messages {
    NSMutableArray *typedMessages = [NSMutableArray array];
    for (AVIMMessage *message in messages) {
        if ([message isKindOfClass:[AVIMTypedMessage class]]) {
            [typedMessages addObject:message];
        }
    }
    return typedMessages;
}

- (NSString *)fetchDataOfMessageFile:(AVFile *)file fileName:(NSString*)fileName error:(NSError**)error{
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:fileName];
    NSData *data = [file getData:error];
    if(*error == nil) {
        [data writeToFile:path atomically:YES];
    }
    return path;
}

- (XHMessage *)displayMessageByAVIMTypedMessage:(AVIMTypedMessage*)typedMessage {
    AVIMMessageMediaType msgType = typedMessage.mediaType;
    XHMessage *message;
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:typedMessage.sendTimestamp/1000];
    NSString *displayName = [self displayNameByClientId:typedMessage.clientId];
    switch (msgType) {
        case kAVIMMessageMediaTypeText: {
            AVIMTextMessage *receiveTextMessage = (AVIMTextMessage *)typedMessage;
            message = [[XHMessage alloc] initWithText:receiveTextMessage.text sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeImage: {
            AVIMImageMessage *imageMessage = (AVIMImageMessage *)typedMessage;
            message = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:imageMessage.file.url originPhotoUrl:nil sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeAudio: {
            NSError *error;
            NSString *path = [self fetchDataOfMessageFile:typedMessage.file fileName:typedMessage.messageId error:&error];
            AVIMAudioMessage* audioMessage = (AVIMAudioMessage *)typedMessage;
            message = [[XHMessage alloc] initWithVoicePath:path voiceUrl:nil voiceDuration:[NSString stringWithFormat:@"%.1f",audioMessage.duration] sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeEmotion: {
            AVFile *file = [AVFile fileWithURL:typedMessage.text];
            NSError *error;
            NSString *path = [self fetchDataOfMessageFile:file fileName:typedMessage.messageId error:&error];
            message = [[XHMessage alloc] initWithEmotionPath:path sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeVideo: {
            AVIMVideoMessage *receiveVideoMessage=(AVIMVideoMessage*)typedMessage;
            NSString *format = receiveVideoMessage.format;
            NSError *error;
            NSString *path = [self fetchDataOfMessageFile:typedMessage.file fileName:[NSString stringWithFormat:@"%@.%@",typedMessage.messageId,format] error:&error];
            message = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:path] videoPath:path videoUrl:nil sender:displayName timestamp:timestamp];
            break;
        }
        default:
            break;
    }
    if ([typedMessage.clientId isEqualToString:[LeanChatManager manager].selfClientID]) {
        message.bubbleMessageType = XHBubbleMessageTypeSending;
    } else {
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
    }
    message.avatarUrl = [self avatarUrlByClientId:typedMessage.clientId];
    return message;
}

- (void)insertAVIMTypedMessage:(AVIMTypedMessage *)typedMessage {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XHMessage *message=[self displayMessageByAVIMTypedMessage:typedMessage];
        [weakSelf addMessage:message];
    });
}

- (BOOL)filterError:(NSError*)error {
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                initWithTitle:nil message:error.description delegate:nil
                                cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - user info
/**
 * 配置头像
 */
- (NSString*)avatarUrlByClientId:(NSString*)clientId{
    return @"https://avatars1.githubusercontent.com/u/1969908?v=3&s=200";
}

/**
 * 配置用户名
 */
- (NSString*)displayNameByClientId:(NSString*)clientId{
    return clientId;
}

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
            }
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    if (self.messages.count == 0) {
        return;
    } else {
        if (!self.loadingMoreMessage) {
            self.loadingMoreMessage = YES;
            XHMessage *message = self.messages[0];
            WEAKSELF
            [self.conversation queryMessagesBeforeId:nil timestamp:[message.timestamp timeIntervalSince1970]*1000 limit:kOnePageSize callback:^(NSArray *queryMessages, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *messages = [NSMutableArray array];
                    NSMutableArray *typedMessages = [self filterTypedMessage:queryMessages];
                    for(AVIMTypedMessage *typedMessage in typedMessages){
                        if (weakSelf) {
                            XHMessage *message = [weakSelf displayMessageByAVIMTypedMessage:typedMessage];
                            if (message) {
                                [messages addObject:message];
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf insertOldMessages:messages completion:^{
                            weakSelf.loadingMoreMessage = NO;
                        }];
                    });
                });
            }];
        }
    }
}
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    AVIMTextMessage *sendTextMessage = [AVIMTextMessage messageWithText:text attributes:nil];
    WEAKSELF
    [self.conversation sendMessage:sendTextMessage callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            [weakSelf insertAVIMTypedMessage:sendTextMessage];
            [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
        }
    }];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tmp.jpg"];
    NSData* photoData=UIImageJPEGRepresentation(photo,1.0);
    [photoData writeToFile:filePath atomically:YES];
    AVIMImageMessage *sendPhotoMessage = [AVIMImageMessage messageWithText:nil attachedFilePath:filePath attributes:nil];
    WEAKSELF
    [self.conversation sendMessage:sendPhotoMessage callback:^(BOOL succeeded, NSError *error) {
        if([weakSelf filterError:error]) {
            [weakSelf insertAVIMTypedMessage:sendPhotoMessage];
            [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
        }
    }];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    AVIMVideoMessage *sendVideoMessage = [AVIMVideoMessage messageWithText:nil attachedFilePath:videoPath attributes:nil];
    WEAKSELF
    [self.conversation sendMessage:sendVideoMessage callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            [weakSelf insertAVIMTypedMessage:sendVideoMessage];
            [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
        }
    }];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    AVIMAudioMessage* sendAudioMessage = [AVIMAudioMessage messageWithText:nil attachedFilePath:voicePath attributes:nil];
    WEAKSELF
    [self.conversation sendMessage:sendAudioMessage callback:^(BOOL succeeded, NSError *error) {
        DLog(@"succeed: %d, error:%@ ",succeeded,error);
        if([weakSelf filterError:error]){
            [self insertAVIMTypedMessage:sendAudioMessage];
            [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
        }
    }];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    WEAKSELF
    AVFile *file = [AVFile fileWithName:@"emotion" contentsAtPath:emotionPath];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            AVIMEmotionMessage *sendEmotionMessage=[AVIMEmotionMessage messageWithText:file.url attributes:nil];
            [weakSelf.conversation sendMessage:sendEmotionMessage callback:^(BOOL succeeded, NSError *error) {
                DLog(@"succeed: %d, error:%@ ",succeeded,error);
                if ([weakSelf filterError:error]) {
                    [weakSelf insertAVIMTypedMessage:sendEmotionMessage];
                    [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
                }
            }];
        }
    }];
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
    geoLocationsMessage.avatarUrl = [self avatarUrlByClientId:sender];
    [self addMessage:geoLocationsMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row >= self.messages.count) {
        return YES;
    } else {
        XHMessage *message = [self.messages objectAtIndex:indexPath.row];
        XHMessage *previousMessage = [self.messages objectAtIndex:indexPath.row-1];
        NSInteger interval = [message.timestamp timeIntervalSinceDate:previousMessage.timestamp];
        if (interval > 60 * 3) {
            return YES;
        } else {
            return NO;
        }
    }
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

@end
