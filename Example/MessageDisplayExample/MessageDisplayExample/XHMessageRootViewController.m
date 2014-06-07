//
//  XHMessageRootViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-26.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageRootViewController.h"

#import "XHFoundationCommon.h"

#import "XHNewsTableViewController.h"
#import "XHQRCodeViewController.h"
#import "XHDemoWeChatMessageTableViewController.h"

#import "XHPopMenu.h"
#import "UIView+XHBadgeView.h"

@interface XHMessageRootViewController ()

@property (nonatomic, strong) XHPopMenu *popMenu;

@end

@implementation XHMessageRootViewController

#pragma mark - Action

- (void)enterMessage {
    XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

- (void)enterNewsController {
    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    [self pushNewViewController:newsTableViewController];
}

- (void)enterQRCodeController {
    XHQRCodeViewController *QRCodeViewController = [[XHQRCodeViewController alloc] init];
    [self pushNewViewController:QRCodeViewController];
}

- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}

#pragma mark - Propertys

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 5; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起群聊";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 2: {
                    imageName = @"contacts_add_scan";
                    title = @"扫一扫";
                    break;
                }
                case 3: {
                    imageName = @"contacts_add_photo";
                    title = @"拍照分享";
                    break;
                }
                case 4: {
                    imageName = @"contacts_add_voip";
                    title = @"视频聊天";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        WEAKSELF
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 2) {
                [weakSelf enterQRCodeController];
            }
        };
    }
    return _popMenu;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenuOnView:)];
    
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:@"请问你现在在哪里啊？我在广州天河", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点进入聊天页面，这里有多种显示样式", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", nil];
    self.dataSource = dataSource;
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
    }
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = (indexPath.row % 2) ? @"曾宪华" : @"杨仁捷";
        cell.detailTextLabel.text = self.dataSource[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"avator"];
    }
    
    [cell.imageView setupCircleBadge];
    
    if (indexPath.row == 4) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.097 green:0.633 blue:1.000 alpha:1.000];
    } else {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.row) {
        [self enterNewsController];
    } else {
        [self enterMessage];
    }
}

@end
