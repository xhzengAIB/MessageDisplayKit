//
//  XHProfileTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-10.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHProfileTableViewController.h"

#import "XHStoreManager.h"

#import "XHMoreMyProfileDetailTableViewController.h"
#import "XHMoreMyAlbumTableViewController.h"
#import "XHMoreMyFavoritesTableViewController.h"
#import "XHMoreMyBankCardTableViewController.h"
#import "XHMoreExpressionShopsTableViewController.h"
#import "XHMoreSettingTableViewController.h"

@interface XHProfileTableViewController ()

@end

@implementation XHProfileTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getProfileConfigureArray];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Profile", @"MessageDisplayKitString", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    UITableViewCellStyle currentStyle;
    
    NSString *subtitle;
    
    NSMutableDictionary *sectionDictionary = self.dataSource[section][row];
    if (!section && !row) {
        currentStyle = UITableViewCellStyleSubtitle;
        subtitle = [sectionDictionary valueForKey:@"WeChatNumber"];
    } else {
        currentStyle = UITableViewCellStyleDefault;
        
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:currentStyle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title = [sectionDictionary valueForKey:@"title"];
    NSString *imageName = [sectionDictionary valueForKey:@"image"];
    
    if (title) {
        cell.textLabel.text = title;
    }
    
    if (subtitle) {
        cell.detailTextLabel.text = subtitle;
    }
    
    if (imageName) {
        cell.imageView.image = [UIImage imageNamed:imageName];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section && !indexPath.row) {
        return 100;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0: {
            XHMoreMyProfileDetailTableViewController *myProfileDetailTableViewController = [[XHMoreMyProfileDetailTableViewController alloc] init];
            viewController = myProfileDetailTableViewController;
            break;
        }
        case 1: {
            switch (row) {
                case 0: {
                    XHMoreMyAlbumTableViewController *myAlbumTableViewController = [[XHMoreMyAlbumTableViewController alloc] init];
                    viewController = myAlbumTableViewController;
                    
                    break;
                }
                case 1: {
                    XHMoreMyFavoritesTableViewController *myFavoritesTableViewController = [[XHMoreMyFavoritesTableViewController alloc] init];
                    viewController = myFavoritesTableViewController;
                    break;
                }
                case 2: {
                    XHMoreMyBankCardTableViewController *myBankCardTableViewController = [[XHMoreMyBankCardTableViewController alloc] init];
                    viewController = myBankCardTableViewController;
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            XHMoreExpressionShopsTableViewController *expressionShopsTableViewController = [[XHMoreExpressionShopsTableViewController alloc] init];
            viewController = expressionShopsTableViewController;
            break;
        }
        case 3: {
            XHMoreSettingTableViewController *settingTableViewController = [[XHMoreSettingTableViewController alloc] init];
            viewController = settingTableViewController;
            
            break;
        }
        default:
            break;
    }
    if (viewController) {
        [self pushNewViewController:viewController];
    }
}

@end
