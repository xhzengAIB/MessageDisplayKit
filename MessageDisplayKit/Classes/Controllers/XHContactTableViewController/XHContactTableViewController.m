//
//  XHContactTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactTableViewController.h"

#import "XHStoreManager.h"
#import "XHContactTableViewCell.h"

#import "XHContactDetailTableViewController.h"

@interface XHContactTableViewController ()

/**
 *  二次确认联系人是否相应的类，并且需要判断联系人的名称是否存在
 *
 *  @param contact 目标联系人对象
 *
 *  @return 返回预想的结果
 */
- (BOOL)validataWithContact:(XHContact *)contact;

@end

@implementation XHContactTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.sectionIndexTitles = [UILocalizedIndexedCollation.currentCollation sectionIndexTitles];
    self.dataSource = [[XHStoreManager shareStoreManager] getContactConfigureArray];
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.sectionIndexColor = [UIColor colorWithRed:0.122 green:0.475 blue:0.992 alpha:1.000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Contact Helper Method

- (BOOL)validataWithContact:(XHContact *)contact {
    return (contact && [contact isKindOfClass:[XHContact class]] && contact.contactName);
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"contactTableViewCellIdentifier";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *contacts;
    
    XHContact *contact;
    
    // 判断是否是搜索tableView
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // 获取联系人数组
        contacts = self.filteredDataSource;
        
        // 判断数组越界问题
        if (row < contacts.count) {
            contact = contacts[row];
            
            if ([self validataWithContact:contact]) {
                [cell configureContact:contact inContactType:XHContactTypeFilter searchBarText:[self getSearchBarText]];
            }
        }
    } else {
        
        // 默认通信录的tableView
        if (section < self.dataSource.count) {
            // 获取联系人数组
            contacts = self.dataSource[section];
            
            // 判断数组越界问题
            if (row < [contacts count]) {
                contact = contacts[row];
                if ([self validataWithContact:contact]) {
                    [cell configureContact:contact inContactType:XHContactTypeNormal searchBarText:nil];
                }
            }
        }
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self enableForSearchTableView:tableView]) {
        [self pushNewViewController:[[XHContactDetailTableViewController alloc] initWithContact:self.filteredDataSource[indexPath.row]]];
    } else {
        [self pushNewViewController:[[XHContactDetailTableViewController alloc] initWithContact:self.dataSource[indexPath.section][indexPath.row]]];
    }
}

@end
