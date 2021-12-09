class BugFixController : UIViewController {

- (void)testCrash {

    NSLog(@"测试数组越界闪退");
    
    NSArray *array = @[@"元素1", @"元素2", @"元素3"];
    for (NSString *string in array) {
        NSLog(string);
    }
    
    NSString *string = array[2];
    NSLog(@"访问索引为2的元素：" + string);
}

}
