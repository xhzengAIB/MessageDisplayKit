//
//  XHMoreExpressionShopsTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMoreExpressionShopsTableViewController.h"

#import "XHMoreExpressionShopsTableViewCell.h"

#import "XHExpressionDetailTableViewController.h"

@interface XHMoreExpressionShopsTableViewController ()

@property (nonatomic, strong) UIImageView *topEmotionImageView;

@end

@implementation XHMoreExpressionShopsTableViewController

- (void)loadDataSource {
    self.dataSource = (NSMutableArray *)@[@"emotionShopOne", @"emotionShopOne", @"emotionShopOne", @"emotionShopOne", @"emotionShopTwo", @"emotionShopOther", @"emotionShopTwo", @"", @"emotionShopTwo", @"emotionShopOther", @"emotionShopOne", @"emotionShopOther", @"emotionShopTwo", @"emotionShopOne", @"emotionShopTwo"];
}

#pragma mark - Propertys

- (UIImageView *)topEmotionImageView {
    if (!_topEmotionImageView) {
        _topEmotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 160)];
        _topEmotionImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage"];
    }
    return _topEmotionImageView;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Expression", @"MessageDisplayKitString", @"");
    
    self.tableView.tableHeaderView = self.topEmotionImageView;
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XHMoreExpressionShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[XHMoreExpressionShopsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.newExpressionEffect = YES;
    cell.expressionStateType = (indexPath.row % 2 ? XHExpressionStateTypeRemoteExpression : XHExpressionStateTypeDownloadedExpression);
    
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row]];
    cell.textLabel.text = @"甜甜私房猫";
    cell.detailTextLabel.text = @"梦猫小气的甜蜜旅行";
    
    return cell;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XHExpressionDetailTableViewController *expressionDetailTableViewController = [[XHExpressionDetailTableViewController alloc] init];
    [self pushNewViewController:expressionDetailTableViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end
