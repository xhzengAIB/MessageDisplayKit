//
//  XHMoreGameTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMoreGameTableViewController.h"

#import "XHMacro.h"

#import "XHHorizontalGridView.h"

@interface XHMoreGameTableViewController ()

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) XHHorizontalGridView *horizontalGridView;

@end

@implementation XHMoreGameTableViewController

#pragma mark - Propertys

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 160)];
        _topImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage"];
    }
    return _topImageView;
}

- (XHHorizontalGridView *)horizontalGridView {
    if (!_horizontalGridView) {
        _horizontalGridView = [[XHHorizontalGridView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    }
    return _horizontalGridView;
}

#pragma mark - DataSource

- (void)loadDataSource {
    NSMutableArray *gridItems = [[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 1; i <= 16; i ++) {
        XHHorizontalGridItem *gridItem = [[XHHorizontalGridItem alloc] init];
        gridItem.title = @"天天哭跑";
        gridItem.subtitle = @"第一名";
        gridItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"dgame%ld", random() % 2]];
        [gridItems addObject:gridItem];
    }
    self.dataSource = [NSMutableArray arrayWithObjects:gridItems, @[@"game1", @"game2", @"game3", @"game3", @"game2", @"game3", @"game2", @"game3", @"game2", @"game3", @"game1", @"game1", @"game3", @"game2"], nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Gamge", @"MessageDisplayKitString", @"游戏");
    
    [self configureBarbuttonItemStyle:XHBarbuttonItemStyleMore action:^{
        DLog(@"游戏更多");
    }];
    
    self.tableView.tableHeaderView = self.topImageView;
    
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataSource.count)
        return 0;
    if (section) {
        return [self.dataSource[section] count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if (indexPath.section) {
        cellIdentifier = @"CellIdentifier";
    } else {
        cellIdentifier = @"horCellIdentifier";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        if (!indexPath.section) {
            [cell.contentView addSubview:self.horizontalGridView];
        }
    }
    
    if (indexPath.section) {
        cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.section][indexPath.row]];
        cell.textLabel.text = @"全民打怪兽";
        cell.detailTextLabel.text = @"第一名";
    } else {
        self.horizontalGridView.gridItems = self.dataSource[indexPath.section];
        [self.horizontalGridView reloadData];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return 60;
    } else {
        return 100;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!section) {
        return @"已下载的游戏(3)";
    } else {
        return @"未下载的游戏(15)";
    }
}

@end
