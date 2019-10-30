# JHGradualProgressView
渐变进度条
(若图片无法查看，请下载后查看)

![image](https://github.com/xjh093/JHGradualProgressView/blob/master/images.png)

### USE

```
    JHGradualProgressConfig *config = [[JHGradualProgressConfig alloc] init];
    config.colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor greenColor]];
    config.showGradualBorderColor = YES;
    config.borderWidth = 1;
    config.borderColor = [UIColor brownColor];
    //config.duration = 0;
    //config.showAllColor = YES;
    
    JHGradualProgressView *progressView = [[JHGradualProgressView alloc] initWithFrame:CGRectMake(10, 120, kScreenWidth-20, 15) config:config];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        progressView.progress = (arc4random()%10+1)*0.1;
    });
    [self.view addSubview:progressView];
```
