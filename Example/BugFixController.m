//
//  BugFixController.m
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/5/15.
//

#import "BugFixController.h"

@interface BugFixController ()

@end

@implementation BugFixController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"测试页面";
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    CGFloat x = 0; CGFloat y = 0; CGFloat width = 0; CGFloat height = 0;
    
    width = 140;
    height = 40;
    x = SCREEN_W/2 - width/2;
    y = 200;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, y, width, height);
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 4;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [btn setTitle:@"测试数组越界" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testCrash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)testCrash {
    
    NSLog(@"测试数组越界闪退");
    
    NSArray *array = @[@"元素1", @"元素2", @"元素3"];
    for (NSString *string in array) {
        NSLog(@"%@", string);
    }
    
    NSString *string = array[3];
    NSLog(@"访问索引为3的元素：%@", [string substringWithRange:NSMakeRange(0, 1)]);
}

@end
