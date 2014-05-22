//
//  XHContactTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactTableViewController.h"

@interface XHContactTableViewController ()

@end

@implementation XHContactTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sectionIndexTitles = [UILocalizedIndexedCollation.currentCollation sectionIndexTitles];
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@[@"apple"],
                       @[@"bpple"],
                       @[@"cpple"],
                       @[@"dpple"],
                       @[@"epple"],
                       @[@"fpple"],
                       @[@"gpple"],
                       @[@"hpple"],
                       @[@"ipple"],
                       @[@"jpple"],
                       @[@"kpple"],
                       @[@"rpple"],
                       @[@"mpple"],
                       @[@"npple"],
                       @[@"opple"],
                       @[@"ppple"],
                       @[@"qpple"],
                       @[@"rpple"],
                       @[@"spple"],
                       @[@"tpple"],
                       @[@"upple"],
                       @[@"vpple"],
                       @[@"wpple"],
                       @[@"xpple"],
                       @[@"ypple"],
                       @[@"zpple"],
                       @[@"#pple"], nil];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
