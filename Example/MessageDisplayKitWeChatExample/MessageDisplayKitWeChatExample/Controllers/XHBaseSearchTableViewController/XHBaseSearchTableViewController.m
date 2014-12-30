//
//  XHBaseSearchTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseSearchTableViewController.h"

@interface XHBaseSearchTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *aSearchBar;

/**
 *  搜索框绑定的控制器
 */
@property (nonatomic) UISearchDisplayController *searchController;

/**
 *  查找搜索框目前文本是否为搜索目标文本
 *
 *  @param searchText 搜索框的文本
 *  @param scope      搜索范围
 */
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end

@implementation XHBaseSearchTableViewController

#pragma mark - Action

- (void)voiceButtonClicked:(UIButton *)sender {
    [self.searchDisplayController setActive:YES animated:YES];
}

- (void)configureSearchBarLeftIconButton {
    UITextField *searchField;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        searchField = [_aSearchBar.subviews objectAtIndex:1];
    else
        searchField = [((UIView *)[_aSearchBar.subviews objectAtIndex:0]).subviews lastObject];
    
    if ([searchField isKindOfClass:[UITextField class]]) {
        UIButton *leftIconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [leftIconButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtn"] forState:UIControlStateNormal];
        [leftIconButton setImage:[UIImage imageNamed:@"VoiceSearchStartBtn_HL"] forState:UIControlStateHighlighted];
        [leftIconButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        searchField.rightView = leftIconButton;
        searchField.rightViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark - Propertys

- (NSMutableArray *)filteredDataSource {
    if (!_filteredDataSource) {
        _filteredDataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _filteredDataSource;
}

- (UISearchBar *)aSearchBar {
    if (!_aSearchBar) {
        _aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _aSearchBar.delegate = self;
        
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_aSearchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDelegate = self;
        _searchController.searchResultsDataSource = self;
    }
    return _aSearchBar;
}

- (NSString *)getSearchBarText {
    return self.searchDisplayController.searchBar.text.lowercaseString;
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureSearchBarLeftIconButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configuraSectionIndexBackgroundColorWithTableView:self.tableView];
    
    self.tableView.tableHeaderView = self.aSearchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
	[self.filteredDataSource removeAllObjects];
    
    for (NSArray *contacts in self.dataSource) {
        for (id contact in contacts) {
            NSString *contactName = [contact valueForKey:@"contactName"];
            NSComparisonResult result = [contactName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame) {
                [self.filteredDataSource addObject:contact];
            }
        }
    }
}

#pragma mark - SearchTableView Helper Method

- (BOOL)enableForSearchTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return YES;
    }
    return NO;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    return YES;
}
#pragma mark - SearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self enableForSearchTableView:tableView]) {
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self enableForSearchTableView:tableView]) {
        return self.filteredDataSource.count;
    }
    return [self.dataSource[section] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

#pragma mark - UITableView Delegate

//section 头部,为了IOS6的美化
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self enableForSearchTableView:tableView]) {
        return nil;
    }
    BOOL showSection = [[self.dataSource objectAtIndex:section] count] != 0;
    //only show the section title if there are rows in the sections
    
    UIView *customHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 22.0f)];
    customHeaderView.backgroundColor = [UIColor colorWithRed:0.926 green:0.920 blue:0.956 alpha:1.000];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 0, CGRectGetWidth(customHeaderView.bounds) - 15.0f, 22.0f)];
    headerLabel.text = (showSection) ? [[UILocalizedIndexedCollation.currentCollation sectionTitles] objectAtIndex:section] : nil;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    headerLabel.textColor = [UIColor darkGrayColor];
    
    [customHeaderView addSubview:headerLabel];
    return customHeaderView;
}

@end
