
class BugFixController : UIViewController {

- (void)testCrash {
        
        //这是注释内容
        /*
    NSLog(@"测试数组越界闪退");
    */
    NSArray *array = @[@"元素1", @"元素2", @"元素3"];
    for (NSString *string in array) {
        NSLog(string);
    }
    
    NSString *string = array[2];
    NSLog(@"【14:12】访问索引为的元素：" + string);
    
}

}
