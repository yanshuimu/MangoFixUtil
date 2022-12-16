//
//  ViewController.m
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MangoFixUtil.h"
#import "BugFixController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
//
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"MangoFixUtil";
    
    [self setupRightBarItem];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setupSubviews {
    
    [self.view addSubview:self.tableView];
}

- (void)setupRightBarItem {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"测试页面" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"执行本地未加密补丁";
            break;
        case 1:
            cell.textLabel.text = @"生成加密补丁";
            break;
        case 2:
            cell.textLabel.text = @"执行本地已加密补丁";
            break;
        case 3:
            cell.textLabel.text = @"执行远程补丁";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MangoFixUtil *mangoFixUtil = [MangoFixUtil sharedUtil];
    
    switch (indexPath.row) {
        case 0:
            [mangoFixUtil evalLocalUnEncryptedMangoScript];
            break;
        case 1:
            [mangoFixUtil encryptPlainScriptToDocument];
            break;
        case 2:
            [mangoFixUtil evalLocalEncryptedMangoScript];
            break;
        case 3:
            [mangoFixUtil evalRemoteMangoScript];
            break;
        default:
            break;
    }
}

- (void)rightBarItemClick {
    
    BugFixController *ctrl = [[BugFixController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        
        CGFloat x = 0; CGFloat y = 0; CGFloat width = 0; CGFloat height = 0;
        width = SCREEN_W;
        height = SCREEN_H - EDNavBar_H;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
