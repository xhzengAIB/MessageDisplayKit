//
//  XHBaseSearchTableViewController.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHBaseTableViewController.h"

@interface XHBaseSearchTableViewController : XHBaseTableViewController

/**
 *  搜索结果数据源
 */
@property (nonatomic, strong) NSMutableArray *filteredDataSource;

/**
 *  TableView右边的IndexTitles数据源
 */
@property (nonatomic, strong) NSArray *sectionIndexTitles;

/**
 *  判断TableView是否为搜索控制器的TableView
 *
 *  @param tableView 被判断的目标TableView对象
 *
 *  @return 返回是否为预想结果
 */
- (BOOL)enableForSearchTableView:(UITableView *)tableView;

/**
 *  获取搜索框的文本
 *
 *  @return 返回文本对象
 */
- (NSString *)getSearchBarText;

@end
