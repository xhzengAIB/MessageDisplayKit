//
//  XHMessageRootViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-26.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageRootViewController.h"

#import "XHDemoWeChatMessageTableViewController.h"
#import "XHFoundationCommon.h"

@interface XHMessageRootViewController ()

@end

@implementation XHMessageRootViewController

- (void)enterMessage {
    XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:@"请问你现在在哪里啊？我在广州天河", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点进入聊天页面，这里有多种显示样式", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"请问你现在在哪里啊？我在广州天河", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", nil];
    self.dataSource = dataSource;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.origin = CGPointZero;
    tableViewFrame.size.height -= CGRectGetHeight(self.tabBarController.tabBar.bounds) + [XHFoundationCommon getAdapterHeight];
    self.tableView.frame = tableViewFrame;
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
    [self enterMessage];
}

@end
