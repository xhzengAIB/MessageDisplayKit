//
//  MultiSelectViewController.m
//  MultiSelectTableViewController
//
//  Created by molon on 6/7/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MultiSelectViewController.h"
#import "MLLetterIndexNavigationView.h"
#import "MultiSelectItem.h"
#import "MultiSelectTableViewCell.h"
#import "UIView+Convenience.h"
#import "MultiSelectedPanel.h"
#import "MultiSelectSearchResultTableViewCell.h"
#import "UIView+XHRemoteImage.h"

#define kDefaultSectionHeaderHeight 22.0f
#define kDefaultRowHeight 55.0f
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion]floatValue])

@interface MultiSelectViewController ()<UITableViewDataSource,UITableViewDelegate,MLLetterIndexNavigationViewDelegate,MultiSelectedPanelDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) MLLetterIndexNavigationView *letterIndexView;
@property (nonatomic, strong) MultiSelectedPanel *selectedPanel;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, strong) NSMutableArray *selectedIndexes; //记录选择项对应的路径

@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation MultiSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择联系人";
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    self.tableView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    //处理传递进来的数组成字典
    self.dict = [NSMutableDictionary dictionary];
    NSMutableArray *letters = [@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]mutableCopy];
    for (NSString *letter in letters) {
        self.dict[letter] = [NSMutableArray array];//先初始化其
    }
    
    for (MultiSelectItem *item in self.items) {
        NSString *firstLetter = [self firstLetterOfString:item.name];
        [self.dict[firstLetter] addObject:item]; //对应的字母数组添加元素。
    }
    
    //删除没有元素的字母key
    for (NSString *key in [self.dict allKeys]) {
        if (((NSArray*)self.dict[key]).count<=0) {
            [self.dict removeObjectForKey:key];
            [letters removeObject:key]; //由于字典是无序的，这里刚好把此数组作为有效key的排序结果。
        }else{
            //对这个数组进行字母排序，系统方法就可以对汉字排序，第一个汉字的首字母，第二个字母。。。这样来排序。
            self.dict[key] = [((NSArray*)self.dict[key]) sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [((MultiSelectItem *)obj1).name localizedCompare:((MultiSelectItem *)obj2).name];
            }];
        }
    }
    
    //整理完毕，将key的排序结果记录
    self.keys = letters;
    self.letterIndexView.keys = self.keys;
    
    //找到已经选择的项目
    NSMutableArray *selectedItems = [NSMutableArray array];
    NSMutableArray *selectedIndexes = [NSMutableArray array];
    for (NSUInteger section=0; section<self.keys.count; section++) {
        for (NSUInteger row=0; row<((NSArray*)self.dict[self.keys[section]]).count; row++) {
            MultiSelectItem *item = self.dict[self.keys[section]][row];
            if (!item.disabled&&item.selected) {
                [selectedItems addObject:item];
                [selectedIndexes addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            }
        }
    }
    self.selectedItems = selectedItems;
    self.selectedIndexes = selectedIndexes;
    self.selectedPanel.selectedItems = self.selectedItems;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.letterIndexView];
    [self.view addSubview:self.selectedPanel];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UITableView *)tableView
{
	if (!_tableView) {
		_tableView = [[UITableView alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
	}
	return _tableView;
}

- (MLLetterIndexNavigationView *)letterIndexView
{
	if (!_letterIndexView) {
		_letterIndexView = [[MLLetterIndexNavigationView alloc]init];
        _letterIndexView.isNeedSearchIcon = YES;
        _letterIndexView.delegate = self;
	}
	return _letterIndexView;
}

- (MultiSelectedPanel *)selectedPanel
{
	if (!_selectedPanel) {
		_selectedPanel = [MultiSelectedPanel instanceFromNib];
        _selectedPanel.delegate = self;
	}
	return _selectedPanel;
}

- (UISearchBar *)searchBar
{
	if (!_searchBar) {
        UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, 44.0f)];
        searchBar.placeholder = @"搜索";
        searchBar.delegate = self;
        [searchBar sizeToFit];
        _searchBar = searchBar;
	}
	return _searchBar;
}

- (UISearchDisplayController *)searchController
{
	if (!_searchController) {
		_searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
	}
	return _searchController;
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
#define kSelectPanelHeight 44.0f
    self.tableView.frame = CGRectMake(0, 0, self.view.frameWidth, self.view.frameHeight-kSelectPanelHeight);
    
    CGFloat topY = 0.0f;
    //导航View的位置
    if (IOS_VERSION>=7.0) { //简单处理下适配吧
        topY += 20.0f;
        topY += (self.view.frameHeight>self.view.frameWidth)?44.0f:32.0f;
    }
    self.letterIndexView.frame = CGRectMake(self.tableView.frameRight-20.0f, topY, 20.0f, self.view.frameHeight-kSelectPanelHeight-topY);
    
    self.selectedPanel.frame = CGRectMake(0, self.tableView.frameBottom, self.view.frameWidth, kSelectPanelHeight);
    
}

#pragma mark - letter index delegate
- (void)mlLetterIndexNavigationView:(MLLetterIndexNavigationView *)mlLetterIndexNavigationView didSelectIndex:(NSInteger)index
{
    if (index==0) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }else{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        return self.keys.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return [((NSArray*)self.dict[self.keys[section]]) count];
    }
    
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        static NSString *CellIdentifier = @"MultiSelectTableViewCell";
        MultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [MultiSelectTableViewCell instanceFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        MultiSelectItem *item = ((NSArray*)self.dict[self.keys[indexPath.section]])[indexPath.row];
        
        [cell.cellImageView setImageWithURL:item.imageURL];
        cell.label.text = item.name;
        if (item.disabled) {
            cell.selectState = MultiSelectTableViewSelectStateDisabled;
        }else{
            cell.selectState = item.selected?MultiSelectTableViewSelectStateSelected:MultiSelectTableViewSelectStateNoSelected;
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"MultiSelectSearchResultTableViewCell";
    MultiSelectSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [MultiSelectSearchResultTableViewCell instanceFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    MultiSelectItem *item = self.searchResult[indexPath.row];
    [cell.cellImageView setImageWithURL:item.imageURL];
    cell.contentLabel.text = item.name;
    if (item.disabled) {
        cell.contentLabel.textColor = [UIColor grayColor];
    }
    if (item.selected||item.disabled) {
        cell.addedTipsLabel.hidden = NO;
    }
    
    return cell;
}

#pragma mark - tableView delegate
//section 头部,为了IOS6的美化
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        UIView *customHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frameWidth, kDefaultSectionHeaderHeight)];
        customHeaderView.backgroundColor = [UIColor colorWithRed:0.926 green:0.920 blue:0.956 alpha:1.000];
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 0, customHeaderView.frameWidth-15.0f, kDefaultSectionHeaderHeight)];
        headerLabel.text = self.keys[section];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        headerLabel.textColor = [UIColor darkGrayColor];
        [customHeaderView addSubview:headerLabel];
        return customHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return kDefaultSectionHeaderHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.tableView]) {
        MultiSelectItem *item = ((NSArray*)self.dict[self.keys[indexPath.section]])[indexPath.row];
        if (item.disabled) {
            return;
        }
        item.selected = !item.selected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (item.selected) {
            //告诉panel应该添加
            [self.selectedItems addObject:item];
            [self.selectedIndexes addObject:indexPath];
            
            [self.selectedPanel didAddSelectedIndex:self.selectedItems.count-1];
        }else{
            //告诉panel应该删除
            NSUInteger index = [self.selectedItems indexOfObject:item];
            
            [self.selectedItems removeObject:item];
            [self.selectedIndexes removeObject:indexPath];
            
            if (index!=NSNotFound) {
                [self.selectedPanel didDeleteSelectedIndex:index];
            }
        }
        
        return;
    }
    
    //找到点击的item是在哪个
    MultiSelectItem *item = self.searchResult[indexPath.row];
    //找到位置
    for (NSUInteger section=0; section<self.keys.count; section++) {
        for (NSUInteger row=0; row<((NSArray*)self.dict[self.keys[section]]).count; row++) {
            MultiSelectItem *aItem = self.dict[self.keys[section]][row];
            if ([item isEqual:aItem]){
                [self.searchController setActive:NO animated:YES];
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                
                //点击这个位置
                if (!item.selected&&!item.disabled) {
                    [self tableView:self.tableView didSelectRowAtIndexPath:path];
                }
                
                //滚动到这个位置
                [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                
                break;
            }
        }
    }
}

#pragma mark - common
- (NSString*)firstLetterOfString:(NSString*)chinese
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFMutableStringRef)[NSMutableString stringWithString:chinese]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSMutableString *aNSString = (__bridge NSMutableString *)string;
    NSString *finalString = [aNSString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];
    
    
    NSString *firstLetter = [[finalString substringToIndex:1]uppercaseString];
    if (!firstLetter||firstLetter.length<=0) {
        firstLetter = @"#";
    }else{
        unichar letter = [firstLetter characterAtIndex:0];
        if (letter<65||letter>90) {
            firstLetter = @"#";
        }
    }
    return firstLetter;
}

#pragma mark - selelcted panel delegate
- (void)willDeleteRowWithItem:(MultiSelectItem*)item withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel
{
    //在此做对数组元素的删除工作
    NSUInteger index = [self.selectedItems indexOfObject:item];
    if (index==NSNotFound) {
        return;
    }
    
    item.selected = NO;
    
    NSIndexPath *indexPath = self.selectedIndexes[index];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.selectedItems removeObjectAtIndex:index];
    [self.selectedIndexes removeObjectAtIndex:index];
}

- (void)didConfirmWithMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel
{
    [self dismiss];
    // 这里咋弄自己研究，已经选择的为self.selectedItems或者(原本传递进来的items里找selected=YES的)
}

#pragma mark - searchbar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //找到名字里有searchText关键字的
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",searchText];
    self.searchResult = [self.items filteredArrayUsingPredicate:pre];
    
    [self.searchController.searchResultsTableView reloadData];
}

@end
