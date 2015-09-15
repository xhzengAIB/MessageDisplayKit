//
//  XHMessageRootViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-26.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageRootViewController.h"

#import "XHFoundationCommon.h"

#import "XHNewsTableViewController.h"
#import "XHQRCodeViewController.h"
#import "XHDemoWeChatMessageTableViewController.h"
#import "XHCustomCellDemoMessageTableViewController.h"

#import "XHPopMenu.h"
#import "UIView+XHBadgeView.h"

#import "MultiSelectItem.h"
#import "MultiSelectViewController.h"
#import "XHBaseNavigationController.h"


@interface XHMessageRootViewController ()

@property (nonatomic, strong) XHPopMenu *popMenu;

@end

@implementation XHMessageRootViewController

#pragma mark - Action

- (void)enterMessage {
    XHDemoWeChatMessageTableViewController *demoWeChatMessageTableViewController = [[XHDemoWeChatMessageTableViewController alloc] init];
    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

- (void)enterCustomCellMessage {
    XHCustomCellDemoMessageTableViewController *customCellDemoMessageTableViewController = [[XHCustomCellDemoMessageTableViewController alloc] init];
    [self.navigationController pushViewController:customCellDemoMessageTableViewController animated:YES];
}

- (void)enterNewsController {
    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    [self pushNewViewController:newsTableViewController];
}

- (void)enterQRCodeController {
    XHQRCodeViewController *QRCodeViewController = [[XHQRCodeViewController alloc] init];
    [self pushNewViewController:QRCodeViewController];
}

- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}

#pragma mark - Propertys

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 5; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起群聊";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 2: {
                    imageName = @"contacts_add_scan";
                    title = @"扫一扫";
                    break;
                }
                case 3: {
                    imageName = @"contacts_add_photo";
                    title = @"拍照分享";
                    break;
                }
                case 4: {
                    imageName = @"contacts_add_voip";
                    title = @"视频聊天";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        WEAKSELF
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 2) {
                [weakSelf enterQRCodeController];
            }else if (index == 0 ) {
                [weakSelf addContactForGroup];
            }
        };
    }
    return _popMenu;
}

- (void)addContactForGroup {
    //建立100个测试数据
    NSMutableArray *items = [NSMutableArray array];
    //网上拉的昵称列表，请忽视非主流。
    NSArray *names = @[@"貓眼无敌",
                       @"涽暗丶芉咮帘",
                       @"一个人搁浅",
                       @"时间像沙漏一样穿过瓶颈。",
                       @"朶，莪哋囡亾-",
                       @"得不到的在乎",
                       @"请不要留恋 .",
                       @"草bian的戒指",
                       @"y1旧、狠轻狂",
                       @"阿娇的垃圾的死了快回答了",
                       @"Angel、葬爱",
                       @"花无心。",
                       @"別致の情緒",
                       @"最近的心跳╰",
                       @"莪想莪慬嘚",
                       @"祂誓〃：毅丹",
                       @"╃渼锝Ъú橡話♂",
                       @"盗梦空间",
                       @"飘流瓶丶逆反",
                       @"①個〆国产纯货ル",
                       @"请你别敷衍ら",
                       @"乱挺爱4@",
                       @"︶￣浮动",
                       @"无规则 Rules°",
                       @"——拽、杀。",
                       @"1③⒋4.⒈",
                       @"殇、箌茈僞祉",
                       ];
    
    NSArray *avatarURLs = @[
                            @"http://v1.qzone.cc/avatar/201406/08/18/50/53943ff25f268523.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/35/53943c70b54e9227.jpeg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/51/539440434b1c7139.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/48/53943f8408bea913.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/48/53943f8ae0384052.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/49/53943fcbb3be9306.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/38/53943d320f616180.png!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/47/53943f469a925760.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/46/53943f1a6b0ee418.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/47/53943f5ec2961034.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/47/53943f486e7ae921.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/45/53943ebae083b101.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/45/53943ec67c849838.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/45/53943ed21aa91813.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/45/53943ec4449f3999.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/43/53943e4e5733a368.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/43/53943e5d120b6630.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/41/53943dc293e22403.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/43/53943e6188616462.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/43/53943e3b42266017.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/41/53943dea86fa9728.png!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/42/53943e2c732d6796.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/40/53943da63ea18098.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/41/53943dec0428e119.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/41/53943dea86fa9728.png!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/41/53943dec0428e119.jpg!180x180.jpg",
                            @"http://v1.qzone.cc/avatar/201406/08/18/42/53943e2c732d6796.jpg!180x180.jpg",
                            ];
    
    for (NSUInteger i=0; i<names.count; i++) {
        MultiSelectItem *item = [[MultiSelectItem alloc]init];
        item.imageURL = [NSURL URLWithString:avatarURLs[i]];
        item.name = names[i];
        if (i==10||(i>4&&i<8)) {
            item.selected = YES;
        }
        if (i==6||i==9) {
            item.disabled = YES;
        }
        [items addObject:item];
    }
    MultiSelectViewController *vc = [[MultiSelectViewController alloc]init];
    vc.items = items;
    
    XHBaseNavigationController *navVC = [[XHBaseNavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - DataSource

- (void)loadDataSource {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:
                                      @"华捷新闻，点击查看美女新闻呢！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点进入聊天页面，这里有多种显示样式",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击查看自定义消息Cell的样式",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"请问你现在在哪里啊？我在广州天河",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      @"点击我查看最新消息，里面有惊喜哦！",
                                      nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource = dataSource;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenuOnView:)];
    
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
    }
    if (indexPath.row < self.dataSource.count) {
        if (!indexPath.row) {
            cell.textLabel.text = self.dataSource[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"dgame1"];
            cell.detailTextLabel.text = nil;
        } else {
            cell.textLabel.text = (indexPath.row % 2) ? @"曾宪华" : @"杨仁捷";
            cell.detailTextLabel.text = self.dataSource[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"customAvatarDefault"];
        }
    }
    
    if (indexPath.row % 2) {
        [cell.imageView setupCircleBadge];
    } else {
        [cell.imageView destroyCircleBadge];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.row == 4) {
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor colorWithRed:0.097 green:0.633 blue:1.000 alpha:1.000];
    } else if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor colorWithRed:0.429 green:0.187 blue:1.000 alpha:1.000];
    } else if (indexPath.row == 6) {
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor colorWithRed:1.000 green:0.222 blue:0.906 alpha:1.000];
    } else {
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.row) {
        [self enterNewsController];
    } else if (indexPath.row == 6) {
        [self enterCustomCellMessage];
    } else {
        [self enterMessage];
    }
}

@end
