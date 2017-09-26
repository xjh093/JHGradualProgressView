# JHGradualProgressView
渐变进度条

![image](https://github.com/xjh093/JHGradualProgressView/blob/master/image.png)

### USE

```
    JHLevelProgressView *progressView = [[JHLevelProgressView alloc] initWithFrame:CGRectMake(10, 75, kScreenWidth-20, 15)];
    progressView.progress = 0.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        progressView.progress = 0.9;
    });
    [self.view addSubview:progressView];
```
