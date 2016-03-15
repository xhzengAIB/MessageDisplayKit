//
//  XHDiscoverTableViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-17.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHDiscoverTableViewController.h"

#import "XHAlbumTableViewController.h"
#import "XHQRCodeViewController.h"
#import "XHShakeViewController.h"
#import "XHLocationServiceTableViewController.h"
#import "XHBottleViewController.h"
#import "XHMoreGameTableViewController.h"

#import "XHStoreManager.h"

#import "UIView+XHBadgeView.h"

@interface XHDiscoverTableViewController ()

@end

@implementation XHDiscoverTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getDiscoverConfigureArray];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < self.dataSource.count) {
        NSDictionary *disconverDictionary = self.dataSource[indexPath.section];
        cell.imageView.image = [UIImage imageNamed:[disconverDictionary valueForKey:@"image"][indexPath.row]];
        cell.textLabel.text = [disconverDictionary valueForKey:@"title"][indexPath.row];
    }
    
    if (indexPath.section == 3) {
        cell.contentView.badgeViewFrame = CGRectMake(120, 12, 50, 20);
        cell.contentView.badgeView.font = [UIFont systemFontOfSize:13];
        cell.contentView.badgeView.text = @"new";
        cell.contentView.badgeView.textColor = [UIColor whiteColor];
        cell.contentView.badgeView.badgeColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma markr - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            [self pushNewViewController:[[XHAlbumTableViewController alloc] init]];
            break;
        }
        case 1: {
            if (indexPath.row) {
                [self pushNewViewController:[[XHShakeViewController alloc] init]];
            } else {
                [self pushNewViewController:[[XHQRCodeViewController alloc] init]];
            }
            break;
        }
        case 2: {
            if (indexPath.row) {
                [self pushNewViewController:[[XHBottleViewController alloc] init]];
            } else {
                [self pushNewViewController:[[XHLocationServiceTableViewController alloc] init]];
            }
            break;
        }
        case 3:
            [self pushNewViewController:[[XHMoreGameTableViewController alloc] init]];
            break;
        default:
            break;
    }
}

@end
