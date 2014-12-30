//
//  XHBaseSearchTableViewController.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
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
