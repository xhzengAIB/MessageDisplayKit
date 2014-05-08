//
//  XHDemoWeChatMessageTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-27.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDemoWeChatMessageTableViewController.h"

@interface XHDemoWeChatMessageTableViewController ()

@property (nonatomic, strong) NSArray *emotionManagers;

@end

@implementation XHDemoWeChatMessageTableViewController

- (void)loadDemoDataSource {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 10; i ++) {
            XHMessage *localPositionMessage = [[XHMessage alloc] initWithLocalPositionPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] sender:@"Jack" timestamp:[NSDate date]];
            localPositionMessage.bubbleMessageType = (i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving;
            [messages addObject:localPositionMessage];
            
            XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:nil voiceUrl:nil sender:@"Jack" timestamp:[NSDate date]];
            voiceMessage.bubbleMessageType = (i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving;
            [messages addObject:voiceMessage];
            
            XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:[[NSBundle mainBundle] pathForResource:@"Demo.gif" ofType:nil] sender:@"曾宪华" timestamp:[NSDate date]];
            emotionMessage.bubbleMessageType = (i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving;
            [messages addObject:emotionMessage];
            
            [messages addObject:[[XHMessage alloc] initWithText:@"这是华捷微信，为什么模仿这个页面效果呢？希望微信团队能看到我们在努力，请微信团队给个机会，让我好好的努力靠近大神，希望自己也能发亮，好像有点过分的希望了，如果大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！Call Me 15915895880" sender:@"华仔" timestamp:[NSDate distantPast]]];
            
            [messages addObject:[[XHMessage alloc] initWithText:@"这是华捷微信，为什么模仿这个页面效果呢？希望微信团队能看到我们在努力，请微信团队给个机会，让我好好的努力靠近大神，希望自己也能发亮，好像有点过分的希望了，如果大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！Call Me 15915895880" sender:@"华仔" timestamp:[NSDate distantPast]]];
            
            XHMessage *message = [[XHMessage alloc] initWithPhoto:[UIImage imageNamed:@"JieIcon"] thumbnailUrl:@"http://www.pailixiu.com/jack/networkPhoto.png" originPhotoUrl:nil sender:@"Jack" timestamp:[NSDate date]];
            message.bubbleMessageType = (i % 2) ? XHBubbleMessageTypeSending : XHBubbleMessageTypeReceiving;
            [messages addObject:message];
            
            
            
        }
        
        [messages addObject:[[XHMessage alloc] initWithText:@"这是华捷微信，为什么模仿这个页面效果呢？希望微信团队能看到我们在努力，请微信团队给个机会，让我好好的努力靠近大神，希望自己也能发亮，好像有点过分的希望了，如果大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！Call Me 15915895880" sender:@"华仔" timestamp:[NSDate distantPast]]];

        for (NSUInteger i = 0; i < 3; i++) {
            [messages addObjectsFromArray:messages];
        }
        
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.messages = messages;
            [weakSelf.messageTableView reloadData];
            
            [weakSelf scrollToBottomAnimated:NO];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Custom UI
//    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundImage:[UIImage imageNamed:@"TableViewBackgroundImage"]];
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_friendcard", @"sharemore_myfav", @"sharemore_wxtalk", @"sharemore_videovoip", @"sharemore_voiceinput", @"sharemore_openapi", @"sharemore_openapi"];
    NSArray *plugTitle = @[@"照片", @"拍摄", @"位置", @"名片", @"我的收藏", @"实时对讲机", @"视频聊天", @"语音输入", @"大众点评", @"应用"];
    for (NSInteger i = 0; i < 10; i ++) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:[plugIcons objectAtIndex:i]] title:[plugTitle objectAtIndex:i]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < 32; j ++) {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Demo%d.gif", j % 2] ofType:@""];
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
    
    [self loadDemoDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self removeMessageAtIndexPath:indexPath];
//    [self insertOldMessages:self.messages];
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

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addMessage:[[XHMessage alloc] initWithText:text sender:sender timestamp:date]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageText];
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessagePhoto];
}

- (void)didSendVideo:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageVideo];
}

- (void)didSendVoice:(NSString *)voicePath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageVoice];
}

- (void)didSendFace:(NSString *)facePath fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageFace];
}

- (void)didSendLocalPosition {
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageLocalPosition];
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2)
        return YES;
    else
        return NO;
}

@end
