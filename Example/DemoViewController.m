//
//  DemoViewController.m
//  MangoFixUtil
//
//  Created by xhg on 2021/5/15.
//

#import "DemoViewController.h"
#import <Masonry/Masonry.h>

@interface DemoViewController ()
//
@property(nonatomic, strong) UIImageView *imageV;
//
@property(nonatomic, strong) UILabel *label;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"测试";
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    _imageV = [UIImageView new];
    _imageV.image = [UIImage imageNamed:@"bg1"];
    [self.view addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(EDNavBar_H);
    }];
    
    _label = [UILabel new];
    _label.textColor = UIColor.whiteColor;
    _label.font = [UIFont systemFontOfSize:18];
    _label.numberOfLines = 0;
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(640);
    }];
    _label.text = @"布衣饭菜，可乐终身111。——沈复《浮生六记》";
}

@end
