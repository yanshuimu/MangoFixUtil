
class BugFixController : UIViewController {

- (void)testCrash {
  
    NSLog(@"本地未加密补丁-数组越界闪退已修复");
          
    NSArray *array = @[@"元素1", @"元素2", @"元素3", @"元素4"];
    
    for (id string in array) {
        NSLog(string);
    }
    
    NSString *string = array.objectAtIndex:(3);
    NSLog(string);
}

}
