//
//  XHContactTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactTableViewController.h"

#import "XHStoreManager.h"
#import "XHContact.h"

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

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sectionIndexTitles = [UILocalizedIndexedCollation.currentCollation sectionIndexTitles];
    self.dataSource = [[XHStoreManager shareStoreManager] getContactConfigureArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method

- (BOOL)validataWithContact:(XHContact *)contact {
    return (contact && [contact isKindOfClass:[XHContact class]] && contact.contactName);
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *contacts;
    
    XHContact *contact;
    
    // 判断是否是搜索tableView
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contacts = self.filteredDataSource;
        
        if (row < contacts.count) {
            contact = contacts[row];
            
            if ([self validataWithContact:contact]) {
                NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:contact.contactName attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.785 alpha:1.000], NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
                [attributedTitle addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor colorWithRed:0.122 green:0.475 blue:0.992 alpha:1.000]
                                        range:[attributedTitle.string.lowercaseString rangeOfString:self.searchDisplayController.searchBar.text.lowercaseString]];
                
                cell.textLabel.attributedText = attributedTitle;
            }
        }
    } else {
        // 默认通信录的tableView
        if (section < self.dataSource.count) {
            contacts = self.dataSource[section];
            
            if (row < [contacts count]) {
                contact = contacts[row];
                if ([self validataWithContact:contact]) {
                    cell.textLabel.text = contact.contactName;
                }
            }
        }
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
